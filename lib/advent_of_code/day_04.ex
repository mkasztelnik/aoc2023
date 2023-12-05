defmodule AdventOfCode.Day04 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&AdventOfCode.Day04.Parser.parse/1)
    |> Enum.map(fn {_, winning, numbers} ->
      MapSet.intersection(MapSet.new(winning), MapSet.new(numbers))
    end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  def part2(input) do
    scors =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&AdventOfCode.Day04.Parser.parse/1)
      |> Enum.map(fn {id, winning, numbers} ->
        winings_size =
          MapSet.intersection(MapSet.new(winning), MapSet.new(numbers)) |> MapSet.size()

        {id, winings_size}
      end)
      |> Enum.map(fn {id, size} -> {id, extras(id, size)} end)
      |> Map.new()

    cards(Map.keys(scors), scors)
  end

  defp extras(_, 0), do: []
  defp extras(id, count), do: Enum.to_list((id + 1)..(id + count))

  defp cards(ids, scors), do: cards(ids, scors, 0)
  defp cards([], _, count), do: count

  defp cards([id | rest], scors, count) do
    case scors[id] do
      nil -> cards(rest, scors, count + 1)
      extra -> cards(extra ++ rest, scors, count + 1)
    end
  end

  defp score(0), do: 0
  defp score(size), do: :math.pow(2, size - 1)
end

defmodule AdventOfCode.Day04.Parser do
  import NimbleParsec

  card_id =
    ignore(string("Card") |> ascii_string([?\s], min: 1)) |> integer(min: 1) |> tag("card_id")

  numbers = repeat(integer(min: 1) |> ignore(ascii_string([?\s], min: 0)))

  defparsec(
    :card,
    card_id
    |> ignore(ascii_string([?\s, ?:], min: 2))
    |> concat(
      numbers
      |> tag("winning")
      |> ignore(ascii_string([?\s, ?|], min: 2))
      |> concat(numbers |> tag("numbers"))
    )
  )

  def parse(line) do
    {:ok, [{"card_id", [id]}, {"winning", winning}, {"numbers", numbers}], "", _, _, _} =
      card(line)

    {id, winning, numbers}
  end
end
