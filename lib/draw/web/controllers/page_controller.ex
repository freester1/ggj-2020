defmodule Draw.Web.PageController do
  use Draw.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end