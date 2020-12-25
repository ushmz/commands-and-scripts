# cmdnotif

Notify you in slack when finish commands execution that takes long time.

## How to use

Add below code to your `~/.zshrc` or `~/.bashrc`.

```shell
export CMD_NOTIFY_SLACK_WEBHOOK_URL="{your slack workspace's webhook URL}"
export CMD_NOTIFY_SLACK_USER_NAME="{slackID you'd like to notify(mention)}"  # NOT USERNAME
source /path/to/cmdnotif
```

## References
- [時間がかかるコマンドの実行結果をSlackに通知する](https://qiita.com/izumin5210/items/c683cb6addc58cae59b6)
- [時間がかかるコマンドを実行した後に通知する - handlename's blog](http://handlename.hatenablog.jp/entry/2013/02/02/190720)
- [時間がかかるコマンドが終了したときに Beep! - f99aq8oveのブログ](http://f99aq.hateblo.jp/entry/20080101/1199196416)
- [Message Attachments | Slack](https://api.slack.com/docs/attachments)
