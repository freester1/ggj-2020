defmodule DrawWeb.GameChannel do
  use DrawWeb, :channel
  alias Draw.Game
  alias Phoenix.Socket

  def join("game:" <> gname, payload, socket) do
    if authorized?(payload) do
      socket = socket
      |> Socket.assign(:name, gname)
      |> Socket.assign(:user, payload["user"])
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("draw", payload, socket) do
    broadcast socket, "draw", payload
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("clear", payload, socket) do
    broadcast socket, "clear", payload
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("guess", %{"word" => word}, socket) do
    gname = socket.assigns[:name]
    user  = socket.assigns[:user]

    game = Game.get(gname)

    cond do
      is_nil(user) ->
        IO.inspect {"invalid user", socket.assigns[:user]}
        {:reply, {:ok, %{}}, socket}
      is_nil(game) ->
        IO.inspect {"invalid game", socket.assigns[:name]}
        {:reply, {:ok, %{}}, socket}
      word == game.word ->
        game = game
        |> Map.put(:word, Game.next_word())
        |> Map.put(:host, user)
        Game.put(gname, game)

        IO.inspect({:update, game})

        broadcast socket, "guess", %{"status" => "win", "word" => word, "user" => user}
        {:reply, {:ok, %{"word" => game[:word]}}, socket}
      true ->
        broadcast socket, "guess", %{"status" => "bad", "word" => word, "user" => user}
        {:reply, {:ok, %{}}, socket}
    end
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  def handle_in("say", payload, socket) do
    IO.inspect {"say", payload}
    broadcast socket, "say", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

