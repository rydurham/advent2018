defmodule Day3 do

  def strategy_one(logs) do
    logs
      |>String.split("\n", trim: true)
      |>Enum.sort
      |>Enum.map(fn(x) ->
        %{
          :timestamp => read_timestamp(String.slice(x, 1..16)),
          :log => String.slice(x, 19..1500),
          :guard => nil
        }
        end)
      |>IO.inspect
  end

  defp read_timestamp(timestamp) do
    %{
      :year => String.to_integer(String.slice(timestamp, 0..3)),
      :month => String.to_integer(String.slice(timestamp, 5..6)),
      :day => String.to_integer(String.slice(timestamp, 8..9)),
      :minute => String.to_integer(String.slice(timestamp, 14..15)),
      :raw => timestamp
    }
  end

end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule Day4Test do
      use ExUnit.Case

      import Day3

      test "strategy_one" do
        assert strategy_one("""
                [1518-11-01 00:05] falls asleep
                [1518-11-01 00:25] wakes up
                [1518-11-01 00:30] falls asleep
                [1518-11-02 00:50] wakes up
                [1518-11-01 00:55] wakes up
                [1518-11-01 00:00] Guard #10 begins shift
                [1518-11-01 23:58] Guard #99 begins shift
                [1518-11-03 00:24] falls asleep
                [1518-11-02 00:40] falls asleep
                [1518-11-03 00:05] Guard #10 begins shift
                [1518-11-03 00:29] wakes up
                [1518-11-04 00:02] Guard #99 begins shift
                [1518-11-04 00:36] falls asleep
                [1518-11-04 00:46] wakes up
                [1518-11-05 00:45] falls asleep
                [1518-11-05 00:55] wakes up
                [1518-11-05 00:03] Guard #99 begins shift
                """) == 240
      end

    end

  [input_file] ->
    answer_one = input_file
      |>File.read!()
      |>Day3.strategy_one
      # |>Integer.to_string

    # answer_two = input_file
    #   |>File.read!()
    #   |>Day3.find_isolated_regions
    #   |>Enum.join(" | ")

    # IO.puts("Answer 1: " <> answer_one)
    # IO.puts("Answer 2: " <> answer_two)

  _ ->
    IO.puts :stderr, "expected --test or an input file"
    System.halt(1)
end
