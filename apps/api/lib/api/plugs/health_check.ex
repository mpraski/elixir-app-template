defmodule Api.Plugs.HealthCheck do
  @moduledoc """
  Plug for routing health check requests 
  """

  alias Api.HealthCheck

  require Logger
  import Plug.Conn
  @behaviour Plug

  def init(_params) do
  end

  def call(%{path_info: ["ready"]} = conn, _opts) do
    conn |> check(&HealthCheck.check_readiness/0)
  end

  def call(%{path_info: ["live"]} = conn, _opts) do
    conn |> check(&HealthCheck.check_liveness/0)
  end

  # nope, not for us, pass it down the chain.
  def call(conn, _opts), do: conn

  # Private

  defp check(conn, fun) when is_function(fun, 0) do
    case fun.() do
      :ok ->
        conn |> send_resp(:ok, "")

      {:error, error} ->
        Logger.error("Health check failed: #{error}")
        conn |> send_resp(:internal_server_error, "")
    end
    |> halt()
  end
end
