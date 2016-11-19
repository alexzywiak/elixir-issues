defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_table_for_columns: 2]
  import Issues.GithubIssues, only: [decode_response: 1, convert_to_list_of_maps: 1, sort_into_ascending_order: 1]
  @default_count 4

  def main(argv) do
    argv  
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parse do
      { [help: true], _, _ } -> :help

      { _, [user, project ], _} -> { user, project, @default_count }

      { _, [user, project, count], _} -> { user, project, count }

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    issues <user> <project> [count | #{@default_count}]
    """
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> convert_to_list_of_maps
    |> sort_into_ascending_order
    |> Enum.take(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end
end