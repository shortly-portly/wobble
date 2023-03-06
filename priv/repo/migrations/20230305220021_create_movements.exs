defmodule Wobble.Repo.Migrations.CreateMovements do
  use Ecto.Migration

  def change do
    create table(:movements) do
      add :description, :string
      add :amount, :integer

      add :nominal_id, references(:nominals)
      add :transaction_id, references(:transactions)
      timestamps()
    end
  end
end
