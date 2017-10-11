defmodule Draw.Web.GameController do
  use Draw.Web, :controller
  alias Draw.Game

  def show(conn, %{"gtag" => gtag}) do
    user = get_session(conn, :user)
    host = get_session(conn, :host)

    if user do
      render conn, "show.html", user: user, host: host, game: gtag
    else
      conn
      |> put_flash(:error, "Please pick a name")
      |> redirect(to: "/")
    end
  end

  def host(conn, %{"host_data" => game}) do
    conn
    |> put_session(:user, game["host"])
    |> put_session(:host, true)
    |> redirect(to: "/" <> game["name"])
  end

  def join(conn, %{"join_data" => join}) do
    conn
    |> put_session(:user, join["user"])
    |> put_session(:host, false)
    |> redirect(to: "/g/" <> join["game"])
  end
end
