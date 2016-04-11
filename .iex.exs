IEx.configure(alive_prompt: "(%node) %prefix>",
              default_prompt: "%prefix>",
              history_size: -1)

greeting = case :calendar.local_time do
  {{_, 1, 1}, _} -> "Happy New Year"
  {{_, 6, 14}, _} -> "Happy Birthday"
  {{_, 12, 25}, _} -> "Merry Christmas"
  {_, {h, _, _}} when h in 4..11 -> "Good morning"
  {_, {h, _, _}} when h in 12..16 -> "Good afternoon"
  _ -> "Good evening"
end
user = System.get_env("USER")
IO.puts "\n  #{greeting}, #{user}!\n"

defmodule H do
  def observer, do: :observer.start
end
