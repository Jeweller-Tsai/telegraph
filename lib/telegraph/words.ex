defmodule Telegraph.Words do
  def start_link do
    Agent.start_link fn ->
      start_event_manager
      Telegraph.Line.start
      []
    end, name: __MODULE__
  end

  defp start_event_manager do
    {:ok, pid} = GenEvent.start_link name: :words_event_manager
    GenEvent.add_handler pid, Telegraph.Line, []
  end

  def put new_words do
    Agent.cast __MODULE__, fn
      old_words ->
        [old_words | new_words] |> List.flatten
    end
    notify new_words
    :ok
  end

  defp notify new_words do
    spawn fn
      ->
        for word <- new_words do
          GenEvent.notify :words_event_manager, {:next_word, word}
        end
    end
  end

  #def get do
    #Agent.get_and_update __MODULE__, fn
      #words ->
        #[h | t] = words
        #{h, t}
    #end
  #end
end
