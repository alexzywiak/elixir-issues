defmodule Issues.GithubIssues do
  require Logger

  @user_agent [ {"User-Agent", "alexzywiak"}]
  @github_url Application.get_env(:issues, :github_url)

  def convert_to_list_of_maps(list) do
    list
      |> Enum.map(&(Enum.into(&1, Map.new)))
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error, bro.  #{message}"
    System.halt(2)
  end

  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project #{project}"
    issues_url(user, project)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do 
    Logger.info "Successful Fetch"
    Logger.debug fn -> inspect(body) end
    { :ok, :jsx.decode(body) }
  end
  def handle_response({:error,  %{reason: reason}}) do
    Logger.error "Error fetching because: #{reason}"
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def process(user, project, count) do
    fetch(user, project)
      |> decode_response
      |> convert_to_list_of_maps
      |> sort_into_ascending_order
      |> Enum.take(count)
  end

  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues, fn i1, i2 -> i1["created_at"] < i2["created_at"] end
  end
end
