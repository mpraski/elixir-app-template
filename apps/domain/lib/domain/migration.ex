defmodule Domain.Migration do
  @moduledoc """
  Module defining the database migration
  """

  @app :domain

  @doc """
  Performs migrations for all repos in the project
  """
  @spec migrate :: [any]
  def migrate do
    with repos <- repos() do
      unless repos
             |> Task.async_stream(&try_to(fn -> connect(&1) end))
             |> Enum.all?(fn {:ok, result} -> result end) do
        raise "Database connectivity problem"
      end

      for repo <- repos do
        {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
      end
    end
  end

  @doc """
  Rolls back migrations for a specific repo and version
  """
  @spec rollback(atom, any) :: {:ok, any, any}
  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  # Lazily execute the function specified number
  # of times, return true if the function returns {:ok, _},
  # else wait a bit and try again
  defp try_to(fun, steps \\ 100, interval \\ 500) do
    fun
    |> Stream.repeatedly()
    |> Stream.take(steps)
    |> Enum.reduce_while(true, fn
      {:ok, _}, _ ->
        {:halt, true}

      _, _ ->
        :timer.sleep(interval)
        {:cont, false}
    end)
  end

  # Try to connect to the database
  defp connect(repo) do
    Ecto.Adapters.SQL.query(repo, "SELECT 1")
  rescue
    e in DBConnection.ConnectionError -> e
  end

  # Get project repos
  defp repos do
    Application.load(@app)
    # This is not in the phoenix documentation, but it's necessary to ensure :ssl is started
    {:ok, _} = Application.ensure_all_started(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
