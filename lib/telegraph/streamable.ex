defmodule Telegraph.Streamable do
  @limit 30

  def start do
    io_stream |> word_stream |> line_stream |> print
  end

  def print line_stream do
    Enum.each line_stream, fn line -> IO.puts line end
  end

  def io_stream do
    IO.stream(:stdio, :line)
  end

  def word_stream io_stream do
    Stream.transform io_stream, [], fn
      line, acc ->
        words = String.split(line, ~r{\s|\n}, trim: true)
        {words, List.flatten([words | acc])}
    end
  end

  def line_stream word_stream do
    Stream.transform word_stream, "", fn
      word, current_line ->
        new_line = "#{current_line} #{word}" |> String.strip
        if String.length(new_line) >= @limit do
          {[current_line], word}
        else
          {[], new_line}
        end
    end
  end
end
