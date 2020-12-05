# cmdnotif

Notify you in slack when finish commands execution that takes long time.

## How to use

Add below code to your `~/.zshrc` or `~/.bashrc`.

```shell
export CMD_NOTIFY_SLACK_WEBHOOK_URL="{your slack workspace's webhook URL}"
export CMD_NOTIFY_SLACK_USER_NAME="{slackID you'd like to notify(mention)}"  # NOT USERNAME
source /path/to/cmdnotif
```
