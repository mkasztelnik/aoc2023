defmodule AdventOfCode.Day11 do
  def part1(input) do
    solve(input, 2)
  end

  def solve(input, size) do
    map =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    y_expansions = map |> expansion_indexex()
    x_expansions = map |> transpose() |> expansion_indexex()

    find_galaxies(map)
    |> expand(x_expansions, y_expansions, size)
    |> combinations()
    |> Enum.map(fn {{x1, y1}, {x2, y2}} ->
      abs(x1 - x2) + abs(y1 - y2)
    end)
    |> Enum.sum()
  end

  defp expand(galaxies, x_expansions, y_expansions, size) do
    Enum.map(galaxies, fn {x, y} ->
      x_expansion = (Enum.filter(x_expansions, &(&1 < x)) |> length())
      y_expansion = (Enum.filter(y_expansions, &(&1 < y)) |> length())
      {
        x + x_expansion * size - x_expansion,
        y + y_expansion * size - y_expansion,
      }
    end)
  end

  defp find_galaxies(map) do
    Enum.reduce(map, {0, []}, fn line, {y, galaxies} ->
      {_, list} =
        Enum.reduce(line, {0, galaxies}, fn ch, {x, g} ->
          case ch do
            ?# -> {x + 1, [{x, y} | g]}
            _  -> {x + 1, g}
          end
        end)

      {y + 1, list}
    end)
    |> elem(1)
  end

  def combinations(list) do
    Enum.flat_map(list, fn g1 ->
      Enum.flat_map(list, fn g2 ->
        if g1 < g2,
          do: [{g1, g2}],
        else: []
      end)
    end)
  end

  defp expansion_indexex(map) do
    map
    |> Enum.with_index()
    |> Enum.filter(fn {line, _} -> Enum.all?(line, &(&1 == ?.)) end)
    |> Enum.map(&(elem(&1, 1)))
  end

  defp transpose(map) do
    map |> Nx.tensor() |> Nx.transpose() |> Nx.to_list()
  end

  def part2(input) do
    solve(input, 1_000_000)
  end
end
