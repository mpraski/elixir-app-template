defmodule Domain.Repo.Migrations.InitTables do
  use Ecto.Migration

  def change do
    create table(:sample) do
      add(:name, :string)
      add(:email, :string)

      timestamps()
    end
  end
end
