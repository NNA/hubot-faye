clientAuth = outgoing: (message, callback) ->
  # Leave non-subscribe or chat messages alone
  if (message.channel is not '/meta/subscribe' and !/chat/.test(message.channel))
    return callback message

  message.ext ?= {}
  
  message.ext.auth_token = process.env.HUBOT_FAYE_AUTH_TOKEN

  if not message.ext.auth_token
  	throw Error('You need to set HUBOT_FAYE_AUTH_TOKEN env vars for faye to work')

  callback message

module.exports = clientAuth
