defmodule Issues.GithubIssues do
  require Logger

  @user_agent [{"User-Agent", "Elixir nyan@cat.rainbow"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.info "Fetching users #{user}'s project #{project}"
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do 
    Logger.info "Succesful response"
    Logger.debug fn -> inspect(body) end
    {:ok, Poison.Parser.parse!(body) }
  end
  
  def handle_response({_, %{status_code: status, body: body}}) do 
    Logger.info "Error #{status} returned"
    {:error, Poison.Parser.parse!(body)}
  end
end
