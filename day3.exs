defmodule Day3 do

  def count_overlaps(input) do
    input
      |>String.split("\n", trim: true)
      |>expand
      |>count_coordinates
      |>Enum.filter(fn({_coord, count}) -> count >= 2 end)
      |>Enum.count
  end

  def find_isolated_regions(input) do
    regions = input
     |>String.split("\n", trim: true)

    coordinates = regions
      |>expand
      |>count_coordinates

    regions
      |>Enum.filter(fn region -> isolated?(region, coordinates) end)
  end

  defp expand(regions) do
    regions
    |> Enum.map(fn region -> expand_region(region) end)
  end

  defp isolated?(region, coordinates) do
    region
      |>expand_region
      |>Enum.reduce(%{}, fn(region_coord, acc) ->
          Map.put(acc, region_coord, Map.get(coordinates, region_coord))
        end)
      |>Enum.filter(fn({_coord, count}) -> count >= 2 end)
      |>Enum.count == 0
  end

  defp count_coordinates(regions) do
    regions
    |>Enum.reduce([], fn(x, acc) -> x ++ acc end)
    |>Enum.reduce(%{}, fn(x, acc) ->
      if (Map.has_key?(acc, x)) do
        Map.put(acc, x, Map.get(acc, x) + 1)
      else
        Map.put(acc, x, 1)
      end
    end)
  end

  defp expand_region(region) do
    [_id, _, coords, dimensions] = String.split(region, " ")

    [width, height] =
      String.split(dimensions, "x")
      |> Enum.map(&String.to_integer/1)

    [x, y] = coords
      |>String.replace(":", "")
      |>String.split(",", trim: true)
      |>Enum.map(&String.to_integer/1)

    y..(y+height)-1
      |>Enum.flat_map(fn(j) -> build_grid_row(x, j, width) end)
  end

  defp build_grid_row(x, y, width) do
    x..(x+width)-1
      |>Enum.map(fn(i) -> {i, y} end)
  end
end


case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule Day3Test do
      use ExUnit.Case

      import Day3

      test "count_overlaps" do
        assert count_overlaps("""
                #1 @ 1,3: 4x4
                #2 @ 3,1: 4x4
                #3 @ 5,5: 2x2
                """) == 4
      end

      test "find_isolated_regions" do
        assert find_isolated_regions("""
                #1 @ 1,3: 4x4
                #2 @ 3,1: 4x4
                #3 @ 5,5: 2x2
                """) == ["#3 @ 5,5: 2x2"]
      end
    end

  [input_file] ->
    answer_one = input_file
      |>File.read!()
      |>Day3.count_overlaps
      |>Integer.to_string

    answer_two = input_file
      |>File.read!()
      |>Day3.find_isolated_regions
      |>Enum.join(" | ")

    IO.puts("Answer 1: " <> answer_one)
    IO.puts("Answer 2: " <> answer_two)

  _ ->
    IO.puts :stderr, "expected --test or an input file"
    System.halt(1)
end
