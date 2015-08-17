#!/bin/zsh

# Load token string from './token'
TOKEN=`cat ./token`
# Set token to connect slack
export HUBOT_SLACK_TOKEN=$TOKEN

# Tell user we'll start running hubot
echo "\e[36mRunnig hubot...\e[m"

# Set path to node_modules
export PATH="node_modules/.bin:node_modules/hubot/node_modules/.bin:$PATH"

# Run hubot with slack adapter
exec node_modules/.bin/hubot --adapter slack --name "utilbot" "$@"

