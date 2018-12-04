defmodule Day3 do

  def count_overlaps(input) do
    input
      |>String.split("\n", trim: true)
      |>Enum.map(fn region -> expand_region(region) end)
      |>Enum.reduce([], fn(x, acc) -> x ++ acc end)
      |>Enum.reduce(%{}, fn(x, acc) ->
        if (Map.has_key?(acc, x)) do
          Map.put(acc, x, Map.get(acc, x) + 1)
        else
          Map.put(acc, x, 1)
        end
      end)
      |>Enum.filter(fn({_coord, count}) -> count >= 2 end)
      |>Enum.count
  end

  defp expand_region(region) do
    [_id, _, coords, dimensions] = String.split(region, " ")

    [width, height] =
      String.split(dimensions, "x")
      |> Enum.map(fn(i) -> String.to_integer(i) end)

    [x, y] = coords
      |>String.replace(":", "")
      |>String.split(",", trim: true)
      |>Enum.map(fn(i) -> String.to_integer(i) end)

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
    end

  [input_file] ->
    input_file
    |>File.read!()
    |>Day3.count_overlaps
    |>IO.puts

  _ ->
    IO.puts :stderr, "expected --test or an input file"
    System.halt(1)
end
