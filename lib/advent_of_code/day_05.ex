defmodule AdventOfCode.Day05 do
  def part1(input) do
    {seeds, mappings} = input |> AdventOfCode.Day05.Parser.parse()

    seeds
    |> Enum.map(fn seed -> map(seed, mappings) end)
    |> Enum.min()
  end

  defp map(nr, steps) do
    steps
    |> Enum.reduce(nr, fn mappings, current ->
      case Enum.find(mappings,  fn {range, _} -> current in range end) do
        nil -> current
        {_, diff} -> current + diff
      end
    end)
  end

  def part2(input) do
    {seeds, mappings} = input |> AdventOfCode.Day05.Parser.parse()

    ranges = seeds
            |> Enum.chunk_every(2)
            |> Enum.map(fn [from, size] -> from..(from + size - 1) end)

    min.._ =
      Enum.reduce(mappings, ranges, &map_ranges/2)
      |> Enum.min_by(fn from.._ -> from end)

    min
  end

  def map_ranges(mappers, ranges, splitted \\ [])
  def map_ranges([], ranges, splitted), do: ranges ++ splitted
  def map_ranges([{mapper, diff} | todo_mappers], ranges, splitted) do
    {mapped, todos} =
      Enum.reduce(ranges, {[], []}, fn range, {acc_mapped, acc_todos} ->
        {m, t} = split_range(mapper, range)
        {
          Enum.map(m, fn s..e -> (s + diff)..(e + diff) end) ++ acc_mapped,
          t ++ acc_todos
        }
      end)
    map_ranges(todo_mappers, todos, mapped ++ splitted)
  end

  def split_range(ms..me, rs..re = range) when ms <= rs and me >= re, do: {[range], []}
  def split_range(ms..me = mapper, rs..re) when ms > rs and me < re, do: {[mapper], [rs..(ms - 1 ), (me + 1)..re]}
  def split_range(ms..me, rs..re) when ms <= rs and me >= rs and me < re, do: {[rs..me], [(me + 1)..re]}
  def split_range(ms..me, rs..re) when ms > rs and ms <= re and me >= re, do: {[ms..re], [rs..(ms - 1)]}
  def split_range(_, range), do: {[], [range]}
end

defmodule AdventOfCode.Day05.Parser do
  import NimbleParsec

  seeds = ignore(string("seeds: "))
          |> repeat(integer(min: 1) |> ignore(ascii_string([?\s], min: 0)))
          |> tag(:seeds)

  mapping = repeat(integer(min: 1) |> ignore(ascii_string([?\s], min: 0)))
            |> ignore(ascii_string([?\n], min: 1))
  mappings = repeat(wrap(mapping))

  from_to_map = ignore(ascii_string([?\n], min: 0))
        |> (ascii_string([?a..?z], min: 1))
        |> ignore(string("-to-"))
        |> (ascii_string([?a..?z], min: 1))
        |> ignore(string(" map:\n"))
        |> wrap(mappings)
        |> tag(:map)

  defparsec :almanac, seeds |> repeat(from_to_map)

  def parse(input) do
    {:ok, [{:seeds, seeds} | map], "", _, _, _} = almanac(input)
    map = map |> Enum.map(fn {:map, [_, _, mappings]} -> to_ranges(mappings) end)

    {seeds, map}
  end

  defp to_ranges(mappings) do
    mappings
    |> Enum.map(fn [to, from, size] ->
      {from..(from + size - 1), to - from}
    end)
  end
end
