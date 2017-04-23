defmodule Draw.Web.GameController do
  use Draw.Web, :controller

  def show(conn, %{"gtag" => gtag}) do
    render conn, "show.html"
  end
end
