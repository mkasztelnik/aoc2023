defmodule AdventOfCode.Day07 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> solve()
  end

  defp ranking([5]), do: 7
  defp ranking([4, 1]), do: 6
  defp ranking([3, 2]), do: 5
  defp ranking([3, 1, 1]), do: 4
  defp ranking([2, 2, 1]), do: 3
  defp ranking([2, 1, 1, 1]), do: 2
  defp ranking([1, 1, 1, 1, 1]), do: 1

  defp score([a, b, c, d, e]), do: a * 100000000 + b * 1000000 + c * 10000 + d * 100 + e

  defp to_number(?A), do: 14
  defp to_number(?K), do: 13
  defp to_number(?Q), do: 12
  defp to_number(?J), do: 11
  defp to_number(?T), do: 10
  defp to_number(?9), do: 9
  defp to_number(?8), do: 8
  defp to_number(?7), do: 7
  defp to_number(?6), do: 6
  defp to_number(?5), do: 5
  defp to_number(?4), do: 4
  defp to_number(?3), do: 3
  defp to_number(?2), do: 2
  defp to_number(?*), do: 1

  defp to_numbers(list, nil), do: list
  defp to_numbers(list, 5), do: [5 | list]
  defp to_numbers([first | rest], jokers), do: [first + jokers | rest]

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.replace(line, "J", "*") end)
    |> solve()
  end

  defp solve(lines) do
    lines
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line, " ")
      numbers =
        hand
        |> String.to_charlist()
        |> Enum.map(&to_number/1)

      map =
        hand
        |> String.to_charlist()
        |> Enum.reduce(%{}, fn ch, acc ->
          Map.update(acc, ch, 1, fn v -> v + 1 end)
        end)

      {jokers, map} = Map.get_and_update(map, ?*, fn _ -> :pop end)
      type = map |> Map.values() |> Enum.sort(:desc) |> to_numbers(jokers)

      {hand, type, numbers, String.to_integer(bid)}
    end)
    |> Enum.sort_by(fn {_, type, numbers, _,} -> ranking(type) * 10000000000 + score(numbers) end)
    |> Enum.reduce({0, 1}, fn {_, _, _, bid}, {score, rank} -> {score + rank * bid, rank + 1} end)
    |> elem(0)
  end
end
