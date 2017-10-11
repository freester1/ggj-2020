defmodule Draw.Game do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put(name, host, word) do
    game = %{name: name, host: host, word: word}
    Agent.update(__MODULE__, &Map.put(&1, name, game))
  end

  def get(name) do
    Agent.get(__MODULE__, &Map.get(&1, name))
  end

  def next_word do
    words = ~w(
      dog cat horse frog snake
      muffin cookie pizza sandwich
      house car train clock
    )
    Enum.random(words)
  end
end
