defmodule Api.HealthCheck.Plug do
  @moduledoc """
  Plug for routing health check requests 
  """

  import Plug.Conn
  @behaviour Plug

  def init(opts), do: opts

  def call(%{path_info: ["ready"]} = conn, _opts) do
    conn
    |> send_resp(code(Api.HealthCheck.check_readiness()), "")
    |> halt()
  end

  def call(%{path_info: ["live"]} = conn, _opts) do
    conn
    |> send_resp(code(Api.HealthCheck.check_liveness()), "")
    |> halt()
  end

  # nope, not for us, pass it down the chain.
  def call(conn, _opts), do: conn

  # Private

  defp code(r) do
    case r do
      :ok -> :ok
      :error -> :internal_server_error
    end
  end
end
