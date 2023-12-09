defmodule AdventOfCode.Day09 do
  def part1(input) do
    parse(input)
    |> Enum.map(&solve_line_last/1)
    |> Enum.sum()
  end

  defp solve_line_last(numbers) do
    reduce(numbers)
    |> Enum.map(fn step -> List.last(step) end)
    |> Enum.sum()
  end

  defp reduce(numbers), do: reduce(numbers, [numbers])

  defp reduce(numbers, results) do
    step = step(numbers)

    if zeros?(step),
      do: results,
      else: reduce(step, [step | results])
  end

  defp zeros?(numbers) do
    numbers |> Enum.all?(fn x -> x == 0 end)
  end

  defp step(numbers) do
    Enum.chunk_every(numbers, 2, 1, :discard)
    |> Enum.map(fn [x, y] -> y - x end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/-?\d+/, line)
      |> Enum.map(fn [nr] -> String.to_integer(nr) end)
    end)
  end

  def part2(input) do
    parse(input)
    |> Enum.map(&solve_line_first/1)
    |> Enum.sum()
  end

  defp solve_line_first(numbers) do
    reduce(numbers)
    |> Enum.map(fn step -> List.first(step) end)
    |> Enum.reduce([0], fn nr, [prev | _] = acc ->
      [nr - prev | acc]
    end)
    |> List.first()
  end
end
