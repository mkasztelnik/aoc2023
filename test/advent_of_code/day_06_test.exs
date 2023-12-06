defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  @input """
  Time:      7  15   30
  Distance:  9  40  200
  """

  test "part1" do
    result = part1(@input)

    assert result == 288
  end

  test "part2" do
    result = part2(@input)

    assert result == 71503
  end
end
