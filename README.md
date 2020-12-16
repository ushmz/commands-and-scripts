# Commands and Scripts

Trivial commands and scripts that keeps you refrain from little things.

## commands

### ajipsy

Simple command to set Slack status.

#### Usage

Set your slack OAuth access token in `.env` file.
```.env
# Slack OAuth token
SLACK_ACCESS_TOKEN=${YOUR_TOKEN}
```

```sh
ajipsy room2525 # Set Slack Status 'Room2525'
ajipsy room2719 # Set Slack Status 'Room2719'
ajipsy home     # Set SLack Status 'Home'
```

Show help

```sh
repo [-h|--help]
```

### cmdnotif

Notify you in slack when finish commands execution that takes long time.

#### Usage

Add below code to your `~/.zshrc` or `~/.bashrc`.

```shell
export CMD_NOTIFY_SLACK_WEBHOOK_URL="{your slack workspace's webhook URL}"
export CMD_NOTIFY_SLACK_USER_NAME="{slackID you'd like to notify(mention)}"  # NOT USERNAME
source /path/to/cmdnotif
```

### repo

Simple command to open project folder in VScode.

#### Usage

Try opening folder in VScode.

```sh
repo [project_folder_name]
```

Set root folder for search.

```sh
repo -r [repositories_root_folder]
```

Show help

```sh
repo [-h|--help]
```

### snitch

Simple commands to tweet from CLI.

## scripts

### brew_update

Execute form `crontab` to keep upgraded all brew formulae.

### overleaf_backup
Execute from `crontab` to back up overleaf project with git.
