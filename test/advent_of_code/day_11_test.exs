defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  @input """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """

  test "part1" do
    result = part1(@input)

    assert result == 374
  end

  test "part2 10" do
    result = solve(@input, 10)

    assert result == 1030
  end

  test "part2 100" do
    result = solve(@input, 100)

    assert result == 8410
  end
end
