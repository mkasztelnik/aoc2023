defmodule AdventOfCode.Day10 do
  def part1(input) do
    AdventOfCode.Day10.Map.parse(input)
    |> tunnel()
    |> length()
    |> div(2)
  end

  defp tunnel(world) do
    graph = to_graph(world)
    [current, _] = Map.get(graph, world.start)

    tunnel(graph, world.start, current, world.start, [current])
  end

  defp tunnel(_, _, end_point, end_point, points), do: points

  defp tunnel(graph, previous, current, end_point, points) do
    [first, second] = Map.get(graph, current)

    if previous == first,
      do: tunnel(graph, current, second, end_point, [second | points]),
      else: tunnel(graph, current, first, end_point, [first | points])
  end

  defp to_graph(map) do
    graph =
      for x <- 0..(map.max_x - 1), y <- 0..(map.max_y - 1), do: {{x, y}, connections(map, {x, y})}

    graph
    |> Enum.reject(fn {_, list} -> list == [] end)
    |> Map.new()
  end

  defp connections(map, current) do
    value = AdventOfCode.Day10.Map.get(map, current)

    [:left, :up, :right, :down]
    |> Enum.map(fn direction ->
      connection = point(current, direction)
      connection_value = AdventOfCode.Day10.Map.get(map, connection)

      if connection_value in candidates(value, direction),
        do: connection,
        else: nil
    end)
    |> Enum.filter(&(!is_nil(&1)))
  end

  defp candidates(?S, :up), do: [?|, ?F, ?7]
  defp candidates(?S, :down), do: [?|, ?L, ?J]
  defp candidates(?S, :left), do: [?-, ?L, ?F]
  defp candidates(?S, :right), do: [?-, ?7, ?J]

  defp candidates(?|, :up), do: [?|, ?F, ?7, ?S]
  defp candidates(?|, :down), do: [?|, ?L, ?J, ?S]
  defp candidates(?|, :left), do: []
  defp candidates(?|, :right), do: []

  defp candidates(?-, :up), do: []
  defp candidates(?-, :down), do: []
  defp candidates(?-, :left), do: [?-, ?L, ?F, ?S]
  defp candidates(?-, :right), do: [?-, ?7, ?J, ?S]

  defp candidates(?L, :up), do: [?|, ?F, ?7, ?S]
  defp candidates(?L, :down), do: []
  defp candidates(?L, :left), do: []
  defp candidates(?L, :right), do: [?-, ?7, ?J, ?S]

  defp candidates(?J, :up), do: [?|, ?F, ?7, ?S]
  defp candidates(?J, :down), do: []
  defp candidates(?J, :left), do: [?-, ?L, ?F, ?S]
  defp candidates(?J, :right), do: []

  defp candidates(?7, :up), do: []
  defp candidates(?7, :down), do: [?|, ?L, ?J, ?S]
  defp candidates(?7, :left), do: [?-, ?L, ?F, ?S]
  defp candidates(?7, :right), do: []

  defp candidates(?F, :up), do: []
  defp candidates(?F, :down), do: [?|, ?L, ?J, ?S]
  defp candidates(?F, :left), do: []
  defp candidates(?F, :right), do: [?-, ?7, ?J, ?S]

  defp candidates(?., _), do: []

  defp point({x, y}, :up), do: {x, y - 1}
  defp point({x, y}, :down), do: {x, y + 1}
  defp point({x, y}, :left), do: {x - 1, y}
  defp point({x, y}, :right), do: {x + 1, y}

  # check floodfill
  def part2(input) do
    world = AdventOfCode.Day10.Map.parse(input)
    tunnel = world |> tunnel()

    tunnel_set = MapSet.new(tunnel)
    all = MapSet.new(AdventOfCode.Day10.Map.all(world))

    MapSet.difference(all, tunnel_set)
    |> Enum.filter(fn point -> inside?(tunnel, point) end)
    |> length()
  end

  defp inside?(tunnel, {_, y} = point) do
    [first | _] = tunnel

    # winding number calculation
    winding_number =
      Enum.chunk_every(tunnel ++ [first], 2, 1, :discard)
      |> Enum.reduce(0, fn [{_, ay} = a, {_, by} = b], wn ->
        if ay <= y,
          do: if(by > y and cross(a, b, point) > 0, do: wn + 1, else: wn),
          else: if(by <= y and cross(a, b, point) < 0, do: wn - 1, else: wn)
      end)

    winding_number != 0
  end

  defp cross({ax, ay}, {bx, by}, {cx, cy}) do
    (bx - ax) * (cy - ay) - (cx - ax) * (by - ay)
  end
end

defmodule AdventOfCode.Day10.Map do
  defstruct points: {}, max_x: 0, max_y: 0, start: {}

  def parse(input) do
    map =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    start = find_start(map)
    map = map |> Enum.map(&List.to_tuple/1) |> List.to_tuple()

    %AdventOfCode.Day10.Map{
      points: map,
      start: start,
      max_y: tuple_size(map),
      max_x: map |> elem(0) |> tuple_size()
    }
  end

  defp find_start(map) do
    map
    |> Enum.reduce_while(0, fn row, y ->
      case Enum.find_index(row, fn r -> r == ?S end) do
        nil -> {:cont, y + 1}
        x -> {:halt, {x, y}}
      end
    end)
  end

  def all(world) do
    Enum.reduce(0..(world.max_y - 1), [], fn y, points ->
      Enum.reduce(0..(world.max_x - 1), points, fn x, acc ->
        [{x, y} | acc]
      end)
    end)
  end

  def get(map, {x, y}) when x < 0 or y < 0 or x >= map.max_x or y >= map.max_y, do: nil
  def get(map, {x, y}), do: map.points |> elem(y) |> elem(x)
end
