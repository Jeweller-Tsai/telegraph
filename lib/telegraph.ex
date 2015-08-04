defmodule Telegraph do
  use Application

  def start _type, _args do
    Telegraph.Words.start_link
  end

  def print_on node do
    Node.spawn node, __MODULE__, :read_input, []
  end

  def read_input do
    Enum.each IO.stream(:stdio, :line), fn
      line ->
        line |> split |> Telegraph.Words.put
    end
  end

  defp split line do
    String.split(line, ~r{\s|\n}, trim: true)
  end

end
