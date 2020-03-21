defmodule Domain.Migration do
  @moduledoc """
  Module defining the database migration
  """

  @app :domain

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.load(@app)
    # This is not in the phoenix documentation, but it's necessary to ensure :ssl is started
    {:ok, _} = Application.ensure_all_started(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
