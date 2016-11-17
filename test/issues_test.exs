defmodule IssuesTest do
  use ExUnit.Case

  import Issues.CLI, only: [ parse_args: 1 ]
  import Issues.GithubIssues, only: [ sort_into_ascending_order: 1, convert_to_list_of_maps: 1 ]
  
  test "returns help when help flag is switched" do
    assert parse_args(["--help", "some garbage"] ) == :help
  end

  test "returns user, project and count passed" do
    assert parse_args(["some user", "some garbage project", 5] ) == {"some user", "some garbage project", 5}
  end

  test "returns user, project and default count if no count is passed" do
    assert parse_args(["some user", "some garbage project"] ) == {"some user", "some garbage project", 4}
  end

  test "sorts by created_at ascending" do
    results = fake_created_at_list(["c", "a", "b"])
      |> sort_into_ascending_order
    issues = for issue <- results, do: Map.get(issue, "created_at")
    assert issues == ~w{a b c}
  end

  defp fake_created_at_list(values) do
    data = for value <- values, do: [{"created_at", value}, {"other_crap", "xxxx"}]
    convert_to_list_of_maps data
  end
end
