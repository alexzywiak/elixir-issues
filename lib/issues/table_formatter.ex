defmodule Issues.TableFormatter do
  
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: row[header]
    end
  end

  def pad_spaces(tup), do: pad_spaces(tup, " ")
  def pad_spaces({value, space}, char) do
    if String.length(value) < space do
      pad_spaces({value <> char, space}, char)
    else
      value
    end
  end

  def print_header_titles(header_string, value_width) do
    header_string <> Enum.map_join(value_width, " | ", (&pad_spaces(&1)))
  end

  def add_header_margin(header_string, zip_list) do
    margin = Enum.map_join(zip_list, "+-", 
      fn({value, width}) -> pad_spaces({"", String.length(value) + width}, "-") end)
    "#{header_string}\n#{margin}"
  end

  def print_headers(headers, width_list) do
    zip_list = List.zip([headers, width_list])
    ""
      |> print_header_titles(zip_list)
      |> add_header_margin(zip_list)
  end

  def widths_of(columns) do
    for column <- columns, do: column |> Enum.map(&String.length/1) |> Enum.max
  end

  def format_for(width_list) do
    Enum.map_join(width_list, " | ", fn(width) -> "~-#{width}s" end) <> "~n"
  end

  def add_space_to_columns(columns, widths) do
    column_width = List.zip([columns, widths])
    Enum.map column_width, fn({column, width}) -> for value <- column, do: pad_spaces({value, width}) end
  end

  def print_rows(spaced_columns) do
    List.zip(spaced_columns)
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map_join("\n", fn(row) -> Enum.join(row, " | ") end) 
  end

  def hit_it(rows, headers) do
    columns = split_into_columns(rows, headers)
    widths = widths_of(columns)
    headers = print_headers(headers, widths)
    rows = add_space_to_columns(columns, widths)
      |> print_rows
    IO.puts "#{headers}\n#{rows}"
  end
end