# Hubot Faye Adapter

## Description

This is the [FAYE](https://github.com/jcoglan/faye) adapter for hubot that allows you to
publish/subscribe messages using FAYE.

## Installation

* Add `hubot-faye` as a dependency in your hubot's `package.json`
* Install dependencies with `npm install`
* Run hubot with `bin/hubot -a faye`

## Usage

You will need to set some environment variables to use this adapter.

### Heroku
    % heroku config:add HUBOT_FAYE_SERVER="my-chat-app.herokuapp.com"

    % heroku config:add HUBOT_FAYE_PORT="80"

    % heroku config:add HUBOT_FAYE_PATH="bayeux"

    % heroku config:add HUBOT_FAYE_PATH="anonymous"

    % heroku config:add HUBOT_FAYE_PASSWORD="my-secret"

    % heroku config:add HUBOT_FAYE_ROOMS="public"

    % heroku config:add HUBOT_FAYE_EXTENSIONS_DIR="faye_extensions"
    
    % heroku config:add HUBOT_FAYE_AUTH_TOKEN="faye_auth_token"

### Non-Heroku environment variables

    % export HUBOT_SMS_FROM="+14156662671"

	% export HUBOT_FAYE_SERVER="my-chat-app.herokuapp.com"

    % export HUBOT_FAYE_PORT="80"

    % export HUBOT_FAYE_PATH="bayeux"

    % export HUBOT_FAYE_PATH="anonymous"

    % export HUBOT_FAYE_PASSWORD="my-secret"

    % export HUBOT_FAYE_ROOMS="public"

    % export HUBOT_FAYE_EXTENSIONS_DIR="faye_extensions"
    
    % export HUBOT_FAYE_AUTH_TOKEN="faye_auth_token"

## Contribute

Here's the most direct way to get your work merged into the project.

1. Fork the project
2. Clone down your fork
3. Create a feature branch
4. Hack away and add tests, not necessarily in that order
5. Make sure everything still passes by running tests
6. If necessary, rebase your commits into logical chunks without errors
7. Push the branch up to your fork
8. Send a pull request for your branch

## Copyright
Copyright &copy; Nicolas NARDONE. See LICENSE for details.
