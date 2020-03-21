defmodule Gateway.GitHub do
    @moduledoc """
  Example usage of Tesla
  """

  def new(token) do
    Tesla.client([
      {Tesla.Middleware.Headers, %{"Authorization" => token}},
      {Tesla.Middleware.BaseUrl, "https://api.github.com"},
      Tesla.Middleware.JSON
    ])
  end

  def user_repos(client, login) do
    Tesla.get(client, "/user/" <> login <> "/repos")
  end
end
