# Draw

Draw is a multi-player real time "guess the drawing" game.


## Setup

### OSX

```
// install elixir
brew update
brew install elixir
elixir -v 
brew upgrade elixir // if version < 1.4

// install Phoenix Framework
mix local.hex // install Erlang package manager locally
mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez
```

## Local Development

Starting the local server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
