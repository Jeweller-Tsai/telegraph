defmodule Telegraph.Printer do
  use GenEvent

  def handle_event {:print, line}, _ do
    if String.length(line) > 0, do: IO.puts line
    {:ok, nil}
  end

  def init _args do
    {:ok, ""}
  end
end
