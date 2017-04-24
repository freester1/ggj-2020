defmodule Draw.Web.GameChannel do
  use Draw.Web, :channel

  def join("game:" <> _game_id, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("draw", payload, socket) do
    IO.inspect {"draw", payload}
    broadcast socket, "draw", payload
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  def handle_in("guess", payload, socket) do
    IO.inspect {"guess", payload}
    broadcast socket, "guess", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

