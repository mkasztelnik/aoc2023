defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(&numbers/1)
    |> Enum.map(&first_last/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(&scan_numbers/1)
    |> Enum.map(&first_last/1)
    |> Enum.sum()
  end

  defp scan_numbers(list), do: scan_numbers(to_charlist(list), [])

  defp scan_numbers([], result), do: Enum.reverse(result)

  defp scan_numbers([x | rest], result) when x > ?0 and x <= ?9 do
    scan_numbers(rest, [x | result])
  end

  defp scan_numbers([?o, ?n, ?e | rest], result), do: scan_numbers(rest, [?1 | result])
  defp scan_numbers([?t, ?w, ?o | rest], result), do: scan_numbers(rest, [?2 | result])
  defp scan_numbers([?t, ?h, ?r, ?e, ?e | rest], result), do: scan_numbers(rest, [?3 | result])
  defp scan_numbers([?f, ?o, ?u, ?r | rest], result), do: scan_numbers(rest, [?4 | result])
  defp scan_numbers([?f, ?i, ?v, ?e | rest], result), do: scan_numbers(rest, [?5 | result])
  defp scan_numbers([?s, ?i, ?x | rest], result), do: scan_numbers(rest, [?6 | result])
  defp scan_numbers([?s, ?e, ?v, ?e, ?n | rest], result), do: scan_numbers(rest, [?7 | result])

  defp scan_numbers([_ | rest] = [?e, ?i, ?g, ?h, ?t | _], result),
    do: scan_numbers(rest, [?8 | result])

  defp scan_numbers([?n, ?i, ?n, ?e | rest], result), do: scan_numbers(rest, [?9 | result])

  defp scan_numbers([_ | rest], result) do
    scan_numbers(rest, result)
  end

  defp numbers(line) do
    line
    |> to_charlist()
    |> Enum.filter(fn x -> x > ?0 && x <= ?9 end)
  end

  defp first_last(list) do
    first = List.first(list)
    last = List.last(list)

    (first - ?0) * 10 + (last - ?0)
  end
end
