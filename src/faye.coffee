{Robot, Adapter, TextMessage, EnterMessage, LeaveMessage, Response} = require require.main.filename.replace(/hubot$/, ".." )

Check = require('validator').check
Sanitize = require('validator').sanitize
Config = require("#{__dirname}/config.coffee")

Faye = require 'faye'
Fs = require 'fs'
Path = require 'path'
EventEmitter = require('events').EventEmitter

class FayeAdapter extends Adapter
  close: ->
    console.log("$ adapter.close...")

  topic: (command, strings...) ->
    console.log("$ adapter.topic...")

  notice: (user, strings...) ->
    console.log("$ adapter.notice...")
  
  send: (user, strings...) =>
    console.log("$ adapter.send...")
    for str in strings
      if user.room
        console.log "# sending #{str} to room #{user.room} "
        @bot.publish user.room,
          username:     @robot.name,
          plain:        str,
          content:      @bot.prepare_message @robot.name, str
      else
        console.log "don't know how to send it"

  reply: (user, strings...) ->
    console.log("$ adapter.reply...")
    for str in strings
      @send user, "@#{user.name}: #{str}"

  join: (channel) ->
    console.log("$ adapter.notice...")
    @bot.publish "#{channel}",
      username:     @robot.name,
      plain:        "#{@robot.name} has join",
      content:      @bot.prepare_message @robot.name, "#{@robot.name} has join"

  run: ->
    console.log("$ adapter.run...")
    self = @

    @options = 
      server: process.env.HUBOT_FAYE_SERVER || Config.server
      port: process.env.HUBOT_FAYE_PORT || 80
      path: process.env.HUBOT_FAYE_PATH || 'faye'
      user: process.env.HUBOT_FAYE_USER || 'anonymous'
      password: process.env.HUBOT_FAYE_PASSWORD || ''
      avatar: process.env.HUBOT_FAYE_AVATAR || ''
      rooms: process.env.HUBOT_FAYE_ROOMS?.split(',') ? Config.rooms
      extensions_dir: process.env.HUBOT_FAYE_EXTENSIONS_DIR || "#{__dirname}/faye_extensions"

    bot = new FayeClient(@options)
    
    for room in @options.rooms
      console.log "# subscribing to room #{room}"
      bot.subscribe room

    bot.on "TextMessage", (user, message) =>
      console.log("# on.TextMessage: #{user.name}: #{message}")
      @robot.receive new TextMessage user, message, 'messageId'

    self.emit 'connected'

    @bot = bot

exports.use = (robot) ->
  new FayeAdapter robot

class FayeClient extends EventEmitter

  constructor: (options) ->
    @options = options
    
    if not options.server
      throw Error('You need to set HUBOT_FAYE_SERVER env vars for faye to work')

    @client = new Faye.Client options.server + ':' + options.port + '/' + options.path
    @client.addExtension require("./faye_extensions/client_auth")

  subscribe: (room)->
    chat_subscription = @client.subscribe "#{room}", (message) =>
      console.log "# received in [#{room}] #{message.username}: #{message.plain}"
      user = id: '7', name: message.username, room: room
      @emit "TextMessage", user, message.plain
    
    chat_subscription.errback (error) =>
      console.log "# error while subscribing to #{room} #{error.message}"

  publish: (channel, message) ->
    @client.publish channel, message
    console.log("# publish to #{channel}: #{JSON.stringify(message)}")

  prepare_message: (username, message) ->
    return Sanitize(message).entityEncode().replace(/\n/g, "<br>").replace(/\r/g, "<br>");


