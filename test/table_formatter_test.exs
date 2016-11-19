defmodule FormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF
  
  def test_rows do
    [
      [c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1+++c4"],
      [c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4"],
      [c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4"],
      [c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"],
    ]
  end

  def headers, do: [:c1, :c2, :c4]

  def splits_into_three do
    TF.split_into_columns(test_rows, headers)
  end

  test "splits into columns" do
    columns = splits_into_three
    assert length(columns) == length(headers)
    assert List.first(columns) == ["r1 c1", "r2 c1", "r3 c1", "r4 c1"]
    assert List.last(columns) == ["r1+++c4", "r2 c4", "r3 c4", "r4 c4"]
  end

  test "column widths" do
    widths = TF.widths_of(splits_into_three)
    assert widths == [5, 6, 7]
  end

  test "correct format string returned" do
    assert TF.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
  end

  test "Output is correct" do
    result = capture_io fn ->
      TF.print_table_for_columns(test_rows, headers)
    end

    assert result == """
    c1    | c2     | c4     
    ------+--------+--------
    r1 c1 | r1 c2  | r1+++c4
    r2 c1 | r2 c2  | r2 c4  
    r3 c1 | r3 c2  | r3 c4  
    r4 c1 | r4++c2 | r4 c4  
    """
  end
end
