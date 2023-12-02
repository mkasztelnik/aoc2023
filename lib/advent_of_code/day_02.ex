defmodule AdventOfCode.Day02 do
  def part1(input) do
    to_game(input)
    |> Enum.map(&to_max/1)
    |> Enum.filter(fn {_, maxes} ->
      maxes["red"] <= 12 &&
        maxes["green"] <= 13 &&
        maxes["blue"] <= 14
    end)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum()
  end

  def part2(input) do
    to_game(input)
    |> Enum.map(&to_max/1)
    |> Enum.map(fn {_, maxes} ->
      maxes["red"] * maxes["green"] * maxes["blue"]
    end)
    |> Enum.sum()
  end

  def to_max({id, moves}) do
    max = Enum.reduce(moves, %{}, fn move, acc ->
      acc
      |> Map.put("red", max(acc["red"] || 0, move["red"] || 0))
      |> Map.put("green", max(acc["green"] || 0, move["green"] || 0))
      |> Map.put("blue", max(acc["blue"] || 0, move["blue"] || 0))
    end)

    {id, max}
  end


  def to_game(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(&AdventOfCode.Day02.Parser.parse/1)
  end
end


defmodule AdventOfCode.Day02.Parser do
  import NimbleParsec

  game_id = ignore(string("Game "))
            |> integer(min: 1)

  red = integer(min: 1) |> ignore(string(" red")) |> tag("red")
  green = integer(min: 1) |> ignore(string(" green")) |> tag("green")
  blue = integer(min: 1) |> ignore(string(" blue")) |> tag("blue")
  element = choice([red, green, blue])

  grab = times(element |> ignore(optional(string(", "))), min: 1, max: 3) |> tag("grab")
  grabs = repeat(grab |> ignore(optional(string("; ")))) |> tag("grabs")


  defparsec :game,
    game_id
    |> ignore(string(": "))
    |> concat(grabs)

  def parse(line) do
    {:ok, [id, {"grabs", grabs}], "", _, _, _} = game(line)

    {
      id,
      grabs |> Enum.map(fn {"grab", list} -> to_map(list) end)
    }
  end

  defp to_map(grab) do
    for {color, [nr]} <- grab, into: %{}, do: {color, nr}
  end
end
