defmodule Draw.Web.GameController do
  use Draw.Web, :controller
  alias Draw.Games

  def show(conn, %{"gtag" => game}) do
    user = get_session(conn, :user)
    host = get_session(conn, :host)

    if user do
      render conn, "show.html", user: user, host: host, game: game
    else
      conn
      |> put_flash(:error, "Please pick a name")
      |> redirect(to: "/")
    end
  end

  def host(conn, %{"host" => host}) do
    Games.create(host["name"], host["word"])
    conn
    |> put_session(:user, host["name"])
    |> put_session(:host, true)
    |> redirect(to: "/" <> host["game"])
  end

  def join(conn, %{"user" => user}) do
    conn
    |> put_session(:user, user["name"])
    |> put_session(:host, false)
    |> redirect(to: "/" <> user["game"])
  end
end
