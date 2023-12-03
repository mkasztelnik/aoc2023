defmodule AdventOfCode.Day03 do
  def part1(input) do
    {digits, symbols} = input |> parse()

    all_symbols =
      symbols
      |> Enum.map(fn {_, point} -> to_surrounding(point) end)
      |> List.flatten()
      |> MapSet.new()

    digits
    |> Enum.reject(fn {_, indexes} -> MapSet.disjoint?(all_symbols, MapSet.new(indexes)) end)
    |> Enum.map(fn {digit, _} -> to_i(digit) end)
    |> Enum.sum()
  end

  def part2(input) do
    {digits, symbols} = input |> parse()

    stars =
      symbols
      |> Enum.filter(fn {symbol, _} -> symbol == "*" end)
      |> Enum.map(fn {_, point} -> to_surrounding(point) |> MapSet.new() end)

    digits_map =
      digits
      |> Enum.map(fn {digit, indexes} -> {to_i(digit), MapSet.new(indexes)} end)

    stars
    |> Enum.map(fn surroundings ->
      digits_map
      |> Enum.reject(fn {_, indexes} -> MapSet.disjoint?(surroundings, indexes) end)
      |> Enum.map(fn {digit, _} -> digit end)
    end)
    |> Enum.map(fn
      [a, b] -> a * b
      _ -> 0
    end)
    |> Enum.sum()
  end

  defp to_surrounding({x, y}) do
    [
      {x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1},
      {x - 1, y}, {x + 1, y},
      {x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1},
    ]
  end

  defp to_i(str) do
    {nr, _} = Integer.parse(str)
    nr
  end

  defp parse(input) do
    {_, digits, symbols} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({0, [], []}, fn line, {index, digits, symbols} ->
        {
          index + 1,
          get_digits(index, line) ++ digits,
          get_symbols(index, line) ++ symbols
        }
      end)

    {digits, symbols}
  end

  defp get_digits(index, line) do
    numbers = Regex.scan(~r/\d+/, line) |> List.flatten()
    indexes = Regex.scan(~r/\d+/, line, return: :index)
              |> Enum.map(fn [{x, len}] ->
                for xx <- x..(x + len - 1), do: {xx, index}
              end)

    Enum.zip(numbers, indexes)
  end

  defp get_symbols(index, line) do
    numbers = Regex.scan(~r/[^.\d]/, line) |> List.flatten()
    indexes = Regex.scan(~r/[^.\d]/, line, return: :index)
              |> Enum.map(fn [{x, _}] -> {x, index} end)

    Enum.zip(numbers, indexes)
  end
end
