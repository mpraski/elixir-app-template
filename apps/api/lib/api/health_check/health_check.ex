defmodule Api.HealthCheck do
  @moduledoc """
  A server responsible for doing the health checks
  and returning the result to the caller
  """

  # 3 seconds in milliseconds
  @tick_interval 3_000

  use GenServer

  defmodule State do
    @moduledoc """
    Internal state
    """

    defstruct ready: [], live: [], results: {:ok, :ok}
  end

  def start_link({_ready, _live} = state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Add a readiness check
  """
  @spec add_readiness((() -> any)) :: :ok
  def add_readiness(check) when is_function(check, 0) do
    GenServer.cast(__MODULE__, {:add_readiness, check})
  end

  @doc """
  Add a liveness check
  """
  @spec add_liveness((() -> any)) :: :ok
  def add_liveness(check) when is_function(check, 0) do
    GenServer.cast(__MODULE__, {:add_liveness, check})
  end

  @doc """
  Execute readiness checks
  """
  @spec check_readiness :: :ok | {:error, String.t()}
  def check_readiness do
    GenServer.call(__MODULE__, :readiness)
  end

  @doc """
  Execute liness checks
  """
  @spec check_liveness :: :ok | {:error, String.t()}
  def check_liveness do
    GenServer.call(__MODULE__, :liveness)
  end

  # Server

  @impl true
  def init({ready, live}) do
    tick()

    {:ok,
     %State{
       ready: ready,
       live: live
     }}
  end

  @impl true
  def handle_cast({:add_readiness, check}, %State{ready: ready} = state) do
    {:noreply, %State{state | ready: [check | ready]}}
  end

  @impl true
  def handle_cast({:add_liveness, check}, %State{live: live} = state) do
    {:noreply, %State{state | ready: [check | live]}}
  end

  @impl true
  def handle_call(:readiness, _from, %State{results: {ready, _}} = state) do
    {:reply, ready, state}
  end

  @impl true
  def handle_call(:liveness, _from, %State{results: {_, live}} = state) do
    {:reply, live, state}
  end

  @impl true
  def handle_info(:tick, %State{ready: ready, live: live} = state) do
    results = {all_pass?(ready), all_pass?(live)}

    tick()

    {:noreply, %State{state | results: results}}
  end

  # Common checks

  @spec repo?(any) :: (() -> :ok | {:error, String.t()})
  @doc """
  Pings the Ecto `repo` to check if connection is healthy.

  Returns `:ok` or `{:error, "reason"}`.

  ## Examples

      iex> Api.HealthCheck.repo?(MyRepo)
      :ok

  """
  def repo?(repo) do
    fn ->
      result =
        try do
          Ecto.Adapters.SQL.query(repo, "SELECT 1")
        rescue
          e in DBConnection.ConnectionError -> e
        end

      case result do
        {:ok, _} -> :ok
        {:error, _} -> {:error, "Database query failed"}
      end
    end
  end

  @spec alive?(any) :: (() -> :ok | {:error, String.t()})
  @doc """
  Checks if PID returned by `pid_fun` references a living process.

  Returns `:ok` or `{:error, "reason"}`.

  ## Examples

      iex> Api.HealthCheck.alive?(&give_pid/0)
      :ok

  """
  def alive?(pid_fun) do
    fn ->
      if Process.alive?(pid_fun.()) do
        :ok
      else
        {:error, "Process is dead"}
      end
    end
  end

  # Private

  # Schedule another check
  defp tick, do: Process.send_after(self(), :tick, @tick_interval)

  # Perform the checks asynchronously
  defp all_pass?(checks) do
    checks
    |> Task.async_stream(& &1.())
    |> Enum.reduce_while(:ok, fn
      {:ok, :ok}, _ -> {:cont, :ok}
      {:ok, err}, _ -> {:halt, err}
    end)
  end
end
