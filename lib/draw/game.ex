defmodule Draw.Game do

  # A Game is a map with the following keys:
  #  - :name - the name of the game
  #  - :host - the name of the user who's currently drawing
  #  - :word - the word to be drawn

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put(gname, game) do
    Agent.update(__MODULE__, &Map.put(&1, gname, game))
    game
  end

  def get(gname) do
    Agent.get(__MODULE__, &Map.get(&1, gname))
  end

  def join(gname, user) do
    game = get(gname)

    if game do
      game
    else
      game = %{ name: gname, host: user, word: next_word() }
      put(gname, game)
    end
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
