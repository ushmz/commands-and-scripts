# ajipsy 

Simple command to set Slack status.

# Usage

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
