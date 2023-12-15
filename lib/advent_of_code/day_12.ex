defmodule AdventOfCode.Day12 do
  def part1(input) do
    parse(input)
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end

  def solve_folded({row, conditions}) do
    row_unfolded = (for _ <- 1..5, do: row) |> Enum.join("?")
    conditions_unfolded = Enum.reduce(1..5, [], fn _, acc -> conditions ++ acc end)
    solve({row_unfolded, conditions_unfolded})
  end

  def solve({row, conditions}) do
    solve(row, ".", conditions)
  end
  def solve("", _, [0]), do: 1
  def solve("", _, []), do: 1
  def solve("", _, _), do: 0

  def solve("#" <> rest, _, [h | t]), do: solve(rest, "#", [h - 1 | t])

  def solve("." <> rest, "#", [0 | t]), do: solve(rest, ".", t)
  def solve("." <> _rest, "#", _), do: 0
  def solve("." <> rest, ".", t), do: solve(rest, ".", t)

  def solve("?" <> rest, _, []), do: solve(rest, ".", [])
  def solve("?" <> rest, "#", [0 | t]), do: solve(rest, ".", t)
  def solve("?" <> rest, "#", [h | t]), do: solve(rest, "#", [h - 1 | t])
  def solve("?" <> rest, ".", [h | t]) do
    cache({rest, [h | t]}, fn ->
      solve(rest, "#", [h - 1 | t]) + solve(rest, ".", [h | t])
    end)
  end
  def solve(_, _, []), do: 0

  def cache(key, fun) do
    case Process.get(key) do
      nil -> fun.() |> tap(&Process.put(key, &1))
      v -> v
    end
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [row, conditions] = String.split(line, " ")
      {
        row,
        conditions |> String.split(",") |> Enum.map(&String.to_integer/1)
      }
    end)
  end

  def part2(input) do
    parse(input)
    |> Enum.map(&solve_folded/1)
    |> Enum.sum()
  end
end
