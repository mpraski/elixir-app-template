defmodule Domain.Migration do
  @moduledoc """
  Module defining the database migration
  """

  @app :domain

  def migrate do
    with rs <- repos() do
      true = rs |> Enum.all?(&wait/1)

      for repo <- rs do
        {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
      end
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp wait(repo) do
    result =
      try do
        Ecto.Adapters.SQL.query(repo, "SELECT 1")
      rescue
        e in DBConnection.ConnectionError -> e
      end

    case result do
      {:ok, _} -> true
      _ -> wait(repo)
    end
  end

  defp repos do
    Application.load(@app)
    # This is not in the phoenix documentation, but it's necessary to ensure :ssl is started
    {:ok, _} = Application.ensure_all_started(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
