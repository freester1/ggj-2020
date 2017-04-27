defmodule Draw.Game do
  defstruct host: nil, word: "pencil", segs: []

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put(name, host, word) do
    Agent.update(__MODULE__, &Map.put(&1, game))
  end

  def get(name) do
    Agent.get(__MODULE__, &Map.get(&1, name))
  end

  def from_map(mm) do
    %Game{name: mm["name"], host: mm["host"], word: mm["word"]}
  end

  def next_word do
    Enum.random([
      "dog",
      "cat",
      "horse",
      "frog",
      "snake",
      "muffin",
      "cookie",
      "pizza",
    ])
  end
end
