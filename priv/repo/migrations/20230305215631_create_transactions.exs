defmodule Wobble.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :name, :string
      add :date, :date

      add :company_id, references(:companies)

      timestamps()
    end
  end
end
