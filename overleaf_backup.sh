notif_prev_executed_at=`date`
executed_prev=`date +%s`
notif_prev_command=$2
log_name=/Users/yusuk/logs/overleaf/backup_`date "+%Y%m%d_%H%M%S"`.log

cd /Users/yusuk/rabhare6it/DEIM2021_shimizu/
# /usr/local/bin/git pull origin master
/usr/local/bin/git fetch >> ${log_name} 2>&1
/usr/local/bin/git reset --hard origin/master >> ${log_name} 2>&1
/usr/local/bin/git merge origin/master >> ${log_name} 2>&1
/usr/local/bin/git push dest master >> ${log_name} 2>&1

notif_status=$?
if [ -n "${CMD_NOTIFY_SLACK_WEBHOOK_URL+x}" ] && [ -n "${CMD_NOTIFY_SLACK_USER_NAME+x}" ] && [ $notif_status -ne 130 ] && [ $notif_status -ne 146 ]; then
  notif_title=$([ $notif_status -eq 0 ] && echo "Command succeeded :ok_woman:" || echo "Command failed :no_good:")
  notif_color=$([ $notif_status -eq 0 ] && echo "good" || echo "danger")
  executed_time=$( echo "`date +%s` - ${executed_prev}" | bc)
  payload=`cat << EOS
{
  "text": "<@$CMD_NOTIFY_SLACK_USER_NAME>",
  "attachments": [
    {
      "color": "$notif_color",
      "title": "$notif_title",
      "mrkdwn_in": ["fields"],
      "fields": [
        {
          "title": "Task",
          "value": "Backup overlead project",
          "short": false
        },
        {
          "title": "directory",
          "value": "\\\`$(pwd)\\\`",
          "short": false
        },
        {
          "title": "hostname",
          "value": "$(hostname)",
          "short": true
        },
        {
          "title": "user",
          "value": "$(whoami)",
          "short": true
        },
        {
          "title": "executed at",
          "value": "$notif_prev_executed_at",
          "short": true
        },
        {
          "title": "elapsed time",
          "value": "$executed_time seconds",
          "short": true
        }
      ]
    }
  ]
}
EOS
`
  /usr/bin/curl --request POST \
    --header 'Content-type: application/json' \
    --data "$(echo "$payload" | tr '\n' ' ' | tr -s ' ')" \
    $CMD_NOTIFY_SLACK_WEBHOOK_URL
fi
