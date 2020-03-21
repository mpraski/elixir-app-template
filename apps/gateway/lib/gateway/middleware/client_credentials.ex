defmodule Gateway.Middleware.ClientCredentials do
  @moduledoc """
  Tesla middleware for obtaining  and refreshing 
  the Oauth2 access token via the client credentials
  grant type
  """

  @behaviour Tesla.Middleware

  alias Gateway.Middleware.Token

  @impl Tesla.Middleware
  def call(env, next, opts) do
    env
    |> put_token(opts)
    |> put_header(opts)
    |> Tesla.run(next)
  end

  defp put_token(env, opts) do
    token = Keyword.get(opts || [], :token)

    if token && Token.valid?(token) do
      env
    else
      env |> Keyword.put(:token, retrieve_token("", "", ""))
    end
  end

  defp put_header(env, opts) do
    token = Keyword.get(opts || [], :token)
    env |> Tesla.put_headers([Token.auth_header(token)])
  end

  defp retrieve_token(client_id, client_secret, token_url) do
  end
end
