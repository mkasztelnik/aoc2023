defmodule AdventOfCode.Day08 do
  def part1(input) do
    {instructions, map} = parse(input)

    calc_steps(map, instructions, "AAA", fn current -> current == "ZZZ" end)
  end

  defp calc_steps(map, instructions, starting_point, end_condition) do
    Enum.reduce_while(Stream.cycle(instructions), {starting_point, 0}, fn instruction,
                                                                          {current, score} ->
      if end_condition.(current),
        do: {:halt, score},
        else: {:cont, {get(Map.get(map, current), instruction), score + 1}}
    end)
  end

  defp get({left, _}, ?L), do: left
  defp get({_, right}, ?R), do: right

  defp parse(input) do
    [instructions | map] = input |> String.split("\n", trim: true)
    instructions = instructions |> String.to_charlist()

    map =
      map
      |> Enum.map(fn line ->
        [[start], [left], [right]] = Regex.scan(~r/\w+/, line)

        {start, {left, right}}
      end)
      |> Map.new()

    {instructions, map}
  end

  def part2(input) do
    {instructions, map} = parse(input)
    starting_points = map |> Map.keys() |> Enum.filter(fn s -> String.at(s, 2) == "A" end)

    starting_points
    |> Enum.map(fn start ->
      calc_steps(map, instructions, start, fn s -> String.at(s, 2) == "Z" end)
    end)
    |> Enum.reduce(1, fn nr, acc -> div(acc * nr, Integer.gcd(acc, nr)) end)
  end
end
