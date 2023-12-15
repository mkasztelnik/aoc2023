defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  @input """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """

  test "part1" do
    result = part1(@input)

    assert result == 21
  end

  test "solve" do
    assert solve({"#", [1]}) == 1
    assert solve({"#", [1, 2]}) == 0
    assert solve({"##?#", [4]}) == 1
    assert solve({"....##.....#....", [2, 1]}) == 1
    assert solve({"#.#.###", [1, 1, 3]}) == 1
    assert solve({"???.###", [1, 1, 3]}) == 1
    assert solve({".??..??...?##.", [1, 1, 3]}) == 4
    assert solve({"?#?#?#?#?#?#?#?", [1, 3, 1, 6]}) == 1
    assert solve({"????.#...#...", [4,1,1]}) == 1
    assert solve({"????.######..#####.", [1, 6, 5]}) == 4
    assert solve({"?###????????", [3, 2, 1]}) == 10
  end

  test "solve folded" do
    assert solve_folded({"???.###", [1, 1, 3]}) == 1
    assert solve_folded({".??..??...?##.", [1, 1, 3]}) == 16384
  end

  test "part2" do
    result = part2(@input)

    assert result == 525152
  end
end
