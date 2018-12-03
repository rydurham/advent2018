defmodule Day2 do

  def checksum(path) do
    ids = readfile(path)
      |>String.split("\n", trim: true)
      |>Enum.map(fn(x) -> Day2.charcount(x) end)
      |>Enum.reduce(%{:twice => 0, :thrice => 0}, fn (x, acc) ->
          twice =
            if Enum.count(Enum.filter(x, fn({_letter, count}) -> count === 2 end)) > 0 do
              acc[:twice] + 1;
            else
              acc[:twice]
            end

          thrice =
            if Enum.count(Enum.filter(x, fn({_letter, count}) -> count === 3 end)) > 0 do
              acc[:thrice] + 1;
            else
              acc[:thrice]
            end

          %{:twice => twice, :thrice => thrice}
        end)

    IO.puts "Answer 1: " <> Integer.to_string(ids[:twice] * ids[:thrice])
  end

  def findboxes(path) do
    ids = readfile(path)
      |>String.split("\n", trim: true)

    result = Enum.reduce(ids, %{:candidates => [], :ids => ids}, fn(i, acc) ->
      candidate = Enum.reject(acc[:ids], fn(x) -> x == i end)
        |> Enum.map(fn(y) -> Day2.similarity(i, y) end)
        |> Enum.filter(fn(z) -> String.length(z) == (String.length(i) - 1) end)

      candidates =
          if (Enum.count(candidate) > 0) do
            acc[:candidates] ++ candidate
          else
            acc[:candidates]
          end

      %{:candidates => candidates, :ids => acc[:ids]}
    end)

    IO.puts "Answer 2: " <> Enum.at(result[:candidates], 1)
  end

  def similarity(stringA, stringB) do
    lengthA = String.length(stringA)
    lengthB = String.length(stringB)

    if (lengthA != lengthB) do
      raise "string length mismatch"
    end

    result = Enum.reduce(0..(lengthA-1), %{:same => [], :a => String.graphemes(stringA), :b => String.graphemes(stringB)}, fn(i, acc) ->
      same =
        if (Enum.at(acc[:a], i) == Enum.at(acc[:b], i)) do
          acc[:same] ++ [Enum.at(acc[:a], i)]
        else
          acc[:same]
        end
      %{:same => same, :a => acc[:a], :b => acc[:b]}
    end)

    Kernel.to_string(result[:same])
  end

  def readfile(path) do
    # Read the input file
    case File.read path do
      {:ok, file} ->
        file
      {:error, :enoent} ->
        raise :enoent
    end
  end

  def charcount(word) do
    word
      |>String.graphemes()
      |>Enum.reduce(%{}, fn char, acc ->
        Map.put(acc, char, (acc[char] || 0) + 1)
      end)
  end

end

Day2.checksum("input/box_ids.txt")
Day2.findboxes("input/box_ids.txt")
