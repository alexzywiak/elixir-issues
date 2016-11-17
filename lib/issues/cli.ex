defmodule Issues.CLI do
  
  @default_count 4

  def run(argv) do
    parse_args(argv)
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

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
  end
end