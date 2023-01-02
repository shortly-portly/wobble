defmodule Wobble.Repo.Migrations.CreateDead do
  use Ecto.Migration

  def change do
    create table(:dead) do
      add :name, :string

      timestamps()
    end
  end
end
