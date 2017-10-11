defmodule Draw.Web.Router do
  use Draw.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Draw.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/games/host", GameController, :host
    post "/games/join", GameController, :join
    get "/g/:gtag", GameController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", Draw.Web do
  #   pipe_through :api
  # end
end
