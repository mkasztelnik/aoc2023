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
    |> Enum.map(&parse_game/1)
  end

  defp parse_game(row) do
    [game, moves] = String.split(row, ": ")

    [_, id] = String.split(game, " ")

    parsed_moves =
      moves
      |> String.split(": ")
      |> List.last
      |> String.split("; ")
      |> Enum.map(fn x ->
        for record <- String.split(x, ", "), into: %{} do
          [nr, color] = String.split(record, " ")
          {color, to_i(nr)}
        end
      end)

    {to_i(id), parsed_moves}
  end

  defp to_i(str) do
    {parsed, _} = Integer.parse(str)

    parsed
  end
end

