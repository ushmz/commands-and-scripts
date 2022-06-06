CREATE TABLE `websites` (
    `id` INTEGER,
    `domain` VARCHAR(256) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `annotations` (
    `id` INTEGER,
    `batch_id` VARCHAR(64),
    `annotator_id` INTEGER,
    `policy_id` INTEGER,
    `segment_id` INTEGER,
    `category_name` VARCHAR(64),
    `policy_url` VARCHAR(512),
    `date` VARCHAR(32),
    `website_id` INTEGER,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_annotations_website_id`
        FOREIGN KEY (`website_id`) REFERENCES `websites` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `attributes` (
    `id` INTEGER AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    `start_index_in_segment` INTEGER,
    `end_index_in_segment` INTEGER,
    `selected_text` TEXT,
    `value` VARCHAR(64),
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `annotation_attribute_relations` (
    `id` INTEGER AUTO_INCREMENT,
    `annotation_id` INTEGER,
    `attribute_id` INTEGER,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_rel_annotation_id`
        FOREIGN KEY (`annotation_id`) REFERENCES `annotations` (`id`),
    CONSTRAINT `fk_rel_attribute_id`
        FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
