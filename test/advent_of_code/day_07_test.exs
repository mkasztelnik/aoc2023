defmodule AdventOfCode.Day07Test do
  use ExUnit.Case

  import AdventOfCode.Day07

  test "part1" do
    input = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """
    result = part1(input)

    assert result == 6440
  end

  test "part1 extra" do
    input = """
    AAAAA 2
    22222 3
    AAAAK 5
    22223 7
    AAAKK 11
    22233 13
    AAAKQ 17
    22234 19
    AAKKQ 23
    22334 29
    AAKQJ 31
    22345 37
    AKQJT 41
    23456 43
    """
    result = part1(input)

    assert result == 1343
  end

  test "part2" do
    input = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """
    result = part2(input)

    assert result == 5905
  end
end
