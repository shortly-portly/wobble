defmodule Wobble.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :employees, :integer

      timestamps()
    end
  end
end
