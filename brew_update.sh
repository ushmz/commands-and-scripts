notif_prev_executed_at=`date`
executed_prev=`date +%s`
notif_prev_command=$2
log_name=/Users/yusuk/logs/brew/update_`date "+%Y%m%d_%H%M%S"`.log

echo '\nbrew doctor ------------------------------------------------' >> ${log_name} 2>&1
/usr/local/bin/brew doctor >> ${log_name} 2>&1
echo '\nbrew update ------------------------------------------------' >> ${log_name} 2>&1
/usr/local/bin/brew upgrade >> ${log_name} 2>&1
echo '\nbrew cleanup -----------------------------------------------' >> ${log_name} 2>&1
/usr/local/bin/brew cleanup >> ${log_name} 2>&1

function notify_result {
  notif_status=$?
  if [ -n "${CMD_NOTIFY_SLACK_WEBHOOK_URL+x}" ] && [ -n "${CMD_NOTIFY_SLACK_USER_NAME+x}" ] && [ $notif_status -ne 130 ] && [ $notif_status -ne 146 ]; then
    notif_title=$([ $notif_status -eq 0 ] && echo "Command succeeded :ok_woman:" || echo "Command failed :no_good:")
    notif_color=$([ $notif_status -eq 0 ] && echo "good" || echo "danger")
    # executed_time=$(expr \(`date +%s` - ${executed_prev}\) / 60 )
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
          "value": "brew upgrade",
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
          "title": "elapsed time,
          "value": "$executed_time seconds",
          "short": true
        }
      ]
    }
  ]
}
EOS
`

    curl --request POST \
      --header 'Content-type: application/json' \
      --data "$(echo "$payload" | tr '\n' ' ' | tr -s ' ')" \
      $CMD_NOTIFY_SLACK_WEBHOOK_URL
  fi
}

notify_result >> ${log_name} 2>&1
