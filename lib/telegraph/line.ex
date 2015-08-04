defmodule Telegraph.Line do
  use GenEvent

  def start do
    {:ok, pid} = GenEvent.start_link name: :line_event_manager
    GenEvent.add_handler pid, Telegraph.Printer, []
  end

  def init _args do
    {:ok, ""}
  end
  def handle_event {:next_word, next_word}, current_line do
    combine current_line, next_word
  end

  #require IEx
  defp combine current_line, next_word do
    new_line = "#{current_line} #{next_word}" |> String.strip

    if String.length(new_line) > 30 || String.length(current_line) > 30 do
      GenEvent.notify :line_event_manager, {:print, current_line}
      {:ok, next_word}
    else
      {:ok, new_line}
    end
  end

end
