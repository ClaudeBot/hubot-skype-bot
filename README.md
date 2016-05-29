# hubot-skype-bot

A Hubot adapter for the official [Skype Bots API (Preview)][skypebots].

This adapter relies on **Skype NodeJS SDK**.

Refer to Skype Bots [documentation][] for more information.

See [`src/skype.coffee`](src/skype.coffee) for full documentation.


## Getting Started

You need 3 pieces of _credentials_ before getting started with `hubot-skype-bot`: a Skype bot ID, a Microsoft application ID, and a secret associated with the application ID.

### 1. Create Skype Bot

To obtain the Skype bot ID, start by [creating a new Skype bot][createbot] (https://developer.microsoft.com/en-us/skype/bots/manage/Create).

Tick both _"Send and receive messages and content in 1:1 chat"_, and _"Send and receive messages and content in a group chat (limited preview for developer accounts only)"_.

For the _"Messaging Webhook"_, set it to the URL that your bot will be hosted, and accessible from, followed by a `/skype/` path. For example, if you are using [`ngrok`][ngrok] to expose your locally hosted bot, you will be entering something like: `https://unique-id.ngrok.io/skype/`

During the creation process, you will be asked for a _Microsoft Application ID_.

### 2. Create Microsoft Application

There should be a link to the [Microsoft Application Registration Portal][appportal] (https://apps.dev.microsoft.com/). Once you create an application, you will be given an application ID, and a secret associated with the application ID.

### 3. Set Environment Variables

You should now have the 3 aforementioned pieces of _credentials_. Expose them to your bot environment:

```bash
export SKYPE_BOT_ID="BOT ID HERE"
export MICROSOFT_APP_ID="APP ID HERE"
export MICROSOFT_APP_SECRET="APP SECRET HERE"
```


## Installation via NPM

```bash
npm install --save hubot-skype-bot
```

Now, run Hubot with the `skype-bot` adapter:

```bash
./bin/hubot -a skype-bot
```


## Configuration

Variable | Default | Description
--- | --- | ---
`MICROSOFT_APP_ID` | N/A | Your bot's unique ID (https://developer.microsoft.com/en-us/skype/bots/manage)
`MICROSOFT_APP_SECRET` | N/A | A Microsoft application ID to authenticate your bot (https://apps.dev.microsoft.com/)
`SKYPE_BOT_ID` | N/A | A Microsoft application secret associated with your application ID (https://apps.dev.microsoft.com/)


[skypebots]: https://developer.microsoft.com/skype/bots
[documentation]: https://developer.microsoft.com/en-us/skype/bots/docs
[createbot]: https://developer.microsoft.com/en-us/skype/bots/manage/Create
[appportal]: https://apps.dev.microsoft.com/
[ngrok]: https://ngrok.com/
