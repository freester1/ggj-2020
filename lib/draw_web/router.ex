defmodule DrawWeb.Router do
  use DrawWeb, :router

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

  scope "/", DrawWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/games/join", GameController, :join
    get "/g/:gname", GameController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", DrawWeb do
  #   pipe_through :api
  # end
end
