defmodule Day1 do
  def sum(path) do
    sum = Day1.readfile(path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn(x) -> Day1.stripsign(x) end)
      |> Enum.map(fn(x) -> String.to_integer(x) end)
      |> Enum.sum

    IO.puts "Answer 1: " <> Integer.to_string(sum)
  end

  def firstDuplicate(path) do

    frequencies = Day1.readfile(path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn(x) -> Day1.stripsign(x) end)
      |> Enum.map(fn(x) -> String.to_integer(x) end)

    IO.puts "Answer 2: " <> Integer.to_string(calibrate(frequencies))

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

  def stripsign(element) do
    # Remove "+" from strings
    if String.starts_with?(element, "+") do
      String.slice(element, 1..10)
    else
      element
    end
  end

  def calibrate(frequencies) do
    # IO.inspect frequencies
    calibrate(frequencies, 0, [])
  end

  def calibrate(frequencies, acc, history) do
    result = Enum.reduce_while(frequencies, %{:acc => acc, :history => history}, fn x, acc ->
      # IO.inspect acc
      current = acc[:acc] + x
      if (Enum.member?(acc[:history], current)) do
        {:halt, current}
      else
        {:cont, %{:acc => current, :history => acc[:history] ++ [current]}}
      end
    end)
    if is_number(result) do
      result
    else
      calibrate(frequencies, result[:acc], result[:history])
    end
  end

end

Day1.sum("input/frequencies.txt")
Day1.firstDuplicate("input/frequencies.txt")
