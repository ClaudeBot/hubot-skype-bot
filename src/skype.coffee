{Robot, Adapter, TextMessage} = require "hubot"
skype = require "skype-sdk";

class Skype extends Adapter
    constructor: (@robot) ->
        super @robot
        @botService = null
        @appID = process.env.MICROSOFT_APP_ID
        @appSecret = process.env.MICROSOFT_APP_SECRET
        @botID = process.env.SKYPE_BOT_ID
        @apiURL = "https://apis.skype.com"
        @apiTimeout = 15000
        @robot.logger.info "hubot-skype-bot: Adapter loaded."

    _nameFromId: (userId) ->
        parts = userId.split(":")
        parts[parts.length - 1]

    _createUser: (userId, roomId = false, displayName = "") ->
        user = @robot.brain.userForId(userId)
        user.room = roomId if roomId
        user.name = displayName
        if displayName.length < 1
           user.name = @_nameFromId(userId)
        @robot.logger.info("hubot-skype-bot: new user : ", user)
        user

    _processMsg: (msg) ->
        retun unless msg.from? and msg.content?
        user = @_createUser msg.from, msg.to
        _msg = msg.content.trim()

        # Format for PMs
        _msg = @robot.name + " " + _msg if msg.to is @botID

        message = new TextMessage user, _msg, msg.messageId
        @receive(message) if message?

    _sendMsg: (context, msg) ->
        # TODO: add, and test support for rooms ...
        target = context.user.id
        target = context.user.room if context.user.room isnt @botID
        @botService.send(target, msg, true, (err) =>
            @robot.logger.error("hubot-skype-bot: error sending message : ", err) if err?
        )

    send: (envelope, strings...) ->
        @_sendMsg envelope, strings.join "\n"

    reply: (envelope, strings...) ->
        @_sendMsg envelope, envelope.user.name + ": " + strings.join "\n #{envelope.user.name}: "

    run: ->
        unless @appID
            @emit "error", new Error "You must configure the MICROSOFT_APP_ID environment variable."
        unless @appSecret
            @emit "error", new Error "You must configure the MICROSOFT_APP_SECRET environment variable."
        unless @botID
            @emit "error", new Error "You must configure the SKYPE_BOT_ID environment variable."

        @botID = "28:#{@botID}"
        @botService = new skype.BotService
            messaging:
                botId: @botID,
                serverUrl: @apiURL,
                requestTimeout: @apiTimeout,
                appId: @appID,
                appSecret: @appSecret

        @robot.router.post "/skype/", skype.messagingHandler(@botService)

        @botService.on("message", (bot, data) =>
            @_processMsg data
        )

        @botService.on("contactAdded", (bot, data) =>
            @_createUser data.from, false, data.fromDisplayName
        )

        @robot.logger.info "hubot-skype-bot: Adapter running."
        @emit "connected"

exports.use = (robot) ->
    new Skype robot
