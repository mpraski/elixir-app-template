defmodule Api.HealthCheck do
  @moduledoc """
  A server responsible for doing the health checks
  and returning the result to the caller
  """

  use GenServer

  def start_link({_ready, _live} = state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def add_readiness(check) when is_function(check, 0) do
    GenServer.cast(__MODULE__, {:add_readiness, check})
  end

  def add_liveness(check) when is_function(check, 0) do
    GenServer.cast(__MODULE__, {:add_liveness, check})
  end

  def check_readiness do
    GenServer.call(__MODULE__, :readiness)
  end

  def check_liveness do
    GenServer.call(__MODULE__, :liveness)
  end

  # Server

  @impl true
  def init({_ready, _live} = state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:add_readiness, check}, {ready, live}) do
    {:noreply, {[check | ready], live}}
  end

  @impl true
  def handle_cast({:add_liveness, check}, {ready, live}) do
    {:noreply, {ready, [check | live]}}
  end

  @impl true
  def handle_call(:readiness, _from, {ready, _live} = state) do
    {:reply, check(ready), state}
  end

  @impl true
  def handle_call(:liveness, _from, {_ready, live} = state) do
    {:reply, check(live), state}
  end

  # Common checks

  def repo?(repo) do
    fn ->
      result =
        try do
          Ecto.Adapters.SQL.query(repo, "SELECT 1")
        rescue
          e in DBConnection.ConnectionError -> e
        end

      case result do
        {:ok, _} -> true
        _ -> false
      end
    end
  end

  def alive?(pid_fun) do
    fn ->
      Process.alive?(pid_fun.())
    end
  end

  # Private

  defp check(checks) do
    if all_pass?(checks) do
      :ok
    else
      :error
    end
  end

  defp all_pass?(checks) do
    checks
    |> Enum.map(&Task.async/1)
    |> Enum.map(&Task.await/1)
    |> Enum.all?()
  end
end
