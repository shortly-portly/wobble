defmodule Wobble.Repo.Migrations.CreateNominals do
  use Ecto.Migration

  def change do
    create table(:nominals) do
      add :code, :string
      add :name, :string
      add :balance, :integer

      add :company_id, references(:companies)
      add :report_category_id, references(:report_categories)

      timestamps()
    end

    create unique_index(:nominals, [:code, :company_id])
  end
end
