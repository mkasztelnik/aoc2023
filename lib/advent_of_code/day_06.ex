defmodule AdventOfCode.Day06 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_ | numbers] = String.split(line, ~r/\s+/)
      Enum.map(numbers, &to_i/1)
    end)
    |> Enum.zip()
    |> Enum.map(&count_wins/1)
    |> Enum.reduce(1, fn wins, acc -> acc * wins end)
  end

  defp count_wins({time, distance}) do
    delta = :math.sqrt(time * time - 4 * distance)
    x1 = (-time - delta) / -2
    x2 = (-time + delta) / -2

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

  defp to_i(str) do
    {nr, _} = Integer.parse(str)
    nr
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_ | numbers] = String.split(line, ~r/\s+/)
      [Enum.join(numbers) |> to_i()]
    end)
    |> Enum.zip()
    |> Enum.map(&count_wins/1)
    |> Enum.reduce(1, fn wins, acc -> acc * wins end)
  end
end
