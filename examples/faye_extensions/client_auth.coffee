clientAuth = outgoing: (message, callback) ->
      # Leave non-subscribe or chat messages alone
      if (message.channel is not '/meta/subscribe' and !/chat/.test(message.channel))
        return callback message
      
      crypto = require 'crypto'
      sha1   = crypto.createHash 'sha1'

      # Add ext field if it's not present
      message.ext ?= {}

      #Set the auth token
      sha1.update "/chat/#{channel}"
      message.ext.authToken = sha1.digest 'hex'

      #Carry on and send the message to the server
      callback message

module.exports = clientAuth
