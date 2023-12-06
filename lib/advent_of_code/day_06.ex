defmodule AdventOfCode.Day06 do
  def part1(input) do
    calculate(input, fn numbers -> Enum.map(numbers, &String.to_integer/1) end)
  end

  def part2(input) do
    calculate(input, fn numbers -> [Enum.join(numbers) |> String.to_integer()] end)
  end

  defp calculate(input, mapping_function) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_ | numbers] = String.split(line, ~r/\s+/)
      mapping_function.(numbers)
    end)
    |> Enum.zip()
    |> Enum.map(&count_wins/1)
    |> Enum.product()
  end

  defp count_wins({time, distance}) do
    delta = :math.sqrt(time * time - 4 * distance)
    x1 = (time + delta) / 2
    x2 = (time - delta) / 2

    to_floor(x1) - to_ceil(x2) + 1
  end

  defp to_ceil(x) do
    truncated = trunc(x)
    if truncated == x, do: truncated + 1, else: ceil(x)
  end

  defp to_floor(x) do
    truncated = trunc(x)
    if truncated == x, do: truncated - 1, else: floor(x)
  end
end
