Robot = require("hubot").robot()
Adapter = require('hubot').adapter()

faye = require 'faye'
fs = require 'fs'
path = require 'path'

class Faye extends Adapter

  run: ->
    # Client Options
    options = 
      server: process.env.HUBOT_FAYE_SERVER
      port: process.env.HUBOT_FAYE_PORT || 80
      path: process.env.HUBOT_FAYE_PATH || 'bayeux'
      user: process.env.HUBOT_FAYE_USER || 'anonymous'
      password: process.env.HUBOT_FAYE_PASSWORD || ''
      avatar: process.env.HUBOT_FAYE_AVATAR || ''
      rooms: process.env.HUBOT_FAYE_ROOMS?.split(',') ? ['/chat/test_room']
      extensions_dir: process.env.HUBOT_FAYE_EXTENSIONS_DIR || 'src/adapters/faye_extensions'
    
    if not options.server
      throw Error('You need to set HUBOT_FAYE_SERVER env vars for faye to work')

    # Connect to faye server
    @client = new faye.Client options.server + ':' + options.port + '/' + options.path

    # Load all faye extensions
    for file in fs.readdirSync("#{options.extensions_dir}")
      @client.addExtension require(path.resolve("#{options.extensions_dir}/#{file}"))

    for room in options.rooms
      console.log "Subscribing to room #{room}"

      #subscribe to every rooms
      chat_subscription = @client.subscribe "#{room}", (message) =>
        console.log "Faye Adapter got message in #{room} from #{message.username} saying #{message.message}"
        user = id: 3, name: message.username, room: room
        @receive new Robot.TextMessage(user, message.message)
      
      chat_subscription.errback (error) =>
        console.log "Error while subscribing to #{room} #{error.message}"

    # Share the options
    @options = options    
  
  send: (user, strings...) =>
    for str in strings
      if user.room
        console.log "sending #{str} in room #{user.room} "
        @client.publish user.room,
          username:     @robot.name,
          message:      str
      else
        console.log "don't know how to send it"

  reply: (user, strings...) ->
    for str in strings
      @send user, "#{user.name}: #{str}"

  join: (channel) ->
    console.log "### Faye Adapter #{@robot.name} has join channel #{channel}"
    @client.publish "#{channel}",
      username:     @robot.name,
      message:      "#{@robot.name} has join"

exports.use = (robot) ->
  new Faye robot