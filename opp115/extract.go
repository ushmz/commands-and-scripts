package main

import (
	"database/sql"
	"encoding/csv"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"

	_ "github.com/go-sql-driver/mysql"
)

type AttributeValue struct {
	StartIndexInSegment int    `json:"startIndexInSegment"`
	EndIndexInSegment   int    `json:"endIndexInSegment"`
	SelectedText        string `json:"selectedText"`
	Value               string `json:"value"`
}

type OPP115DataRow struct {
	AnnotationID       int
	BatchID            string
	AnnotatorID        int
	PolicyID           int
	SegmentID          int
	CategoryName       string
	AttributeValuePair map[string]AttributeValue
	PolicyURL          string
	Date               string
}

func main() {
	flag.Parse()
	fn := flag.Arg(0)

	f, err := os.Open("./annotations/" + fn)
	if err != nil {
		fmt.Printf("[Skipped] Failed to open file :%v", err)
	}
	defer f.Close()

	db, err := getConnection()
	if err != nil {
		panic(fmt.Sprintf("DB connection failed: %v", err))
	}
	defer db.Close()

	// Insert webpage ID, domain
	wi, dn, err := breakDownFilename(fn)
	if err != nil {
		// Failed to create ID, domainn from file name.
	}
	if _, err := db.Exec(`INSERT INTO websites VALUES (?, ?)`, wi, dn); err != nil {
		fmt.Printf("Failed to insert websites: %v\n", err)
	}

	csvReader := csv.NewReader(f)
	for {
		records, err := csvReader.Read()
		if err != nil {
			if err == io.EOF {
				break
			}
			fmt.Printf("[Skipped] %v", err)
			continue
		}
		func() {
			row := OPP115DataRow{}
			row.AttributeValuePair = map[string]AttributeValue{}
			if id, err := strconv.Atoi(records[0]); err == nil {
				row.AnnotationID = id
			}

			row.BatchID = records[1]

			if id, err := strconv.Atoi(records[2]); err == nil {
				row.AnnotatorID = id
			}

			if id, err := strconv.Atoi(records[3]); err == nil {
				row.PolicyID = id
			}

			if id, err := strconv.Atoi(records[4]); err == nil {
				row.SegmentID = id
			}

			row.CategoryName = records[5]

			p := map[string]json.RawMessage{}
			if err := json.Unmarshal([]byte(records[6]), &p); err != nil {
				fmt.Printf("[Skipped] Failed to unmarshal data: %v\n", err)
			}

			for k, v := range p {
				tmp := row.AttributeValuePair
				a := AttributeValue{}
				if err := json.Unmarshal(v, &a); err != nil {
					fmt.Printf("[Skipped] Failed to unmarshal attribute-value pairs : %v\n", err)
				}
				tmp[k] = a
				row.AttributeValuePair = tmp
			}

			row.Date = records[7]
			row.PolicyURL = records[8]

			attrs := []int{}
			for k, v := range row.AttributeValuePair {
				// Insert attributes => get IDs
				rs, err := db.Exec(`
				INSERT INTO
					attributes(name, start_index_in_segment, end_index_in_segment, selected_text, value)
				VALUES
					(?,?,?,?,?)
			`, k, v.StartIndexInSegment, v.EndIndexInSegment, v.SelectedText, v.Value)
				if err != nil {
					// Failed to insert attributes
					fmt.Printf("Failed to insert AttributeValuePair: %v\n", err)
				}
				attributeID, err := rs.LastInsertId()
				if err != nil {
					// Failed to get generated attribute ID
					fmt.Printf("Failed to get last inserted ID: %v\n", err)
				}
				attrs = append(attrs, int(attributeID))
			}

			// Insert anotaion and relation
			if _, err := db.Exec(
				`INSERT INTO annotations() VALUES (?,?,?,?,?,?,?,?,?)`,
				row.AnnotationID,
				row.BatchID,
				row.AnnotatorID,
				row.PolicyID,
				row.SegmentID,
				row.CategoryName,
				row.PolicyURL,
				row.Date,
				wi,
			); err != nil {
				fmt.Printf("Failed to insert annotations: %v\n", err)
			}

			for _, v := range attrs {
				if _, err := db.Exec(
					`INSERT INTO annotation_attribute_relations(annotation_id, attribute_id) VALUES (?, ?)`,
					row.AnnotationID, v,
				); err != nil {
					fmt.Printf("Failed to insert relations: %v\n", err)
				}
			}
		}()
	}
}

func getEnv(key string) string {
	v, ok := os.LookupEnv(key)
	if !ok {
		return ""
	}
	return v
}

func getConnection() (*sql.DB, error) {
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		getEnv("USER"),
		getEnv("PASSWORD"),
		getEnv("HOST"),
		getEnv("PORT"),
		getEnv("DATABASE"),
	)

	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, err
	}
	return db, nil
}

func breakDownFilename(basename string) (int, string, error) {
	n := strings.Split(basename, "_")
	fmt.Println(n)
	id, err := strconv.Atoi(n[0])
	if err != nil {
		fmt.Printf("parse error %s: %v", n[0], err)
		return 0, "", err
	}

	return id, strings.TrimRight(n[1], "."), nil
}
