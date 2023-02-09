defmodule Wobble.Repo.Migrations.CreateReportCategories do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE report_types AS ENUM ('profit and loss', 'balance sheet')"
    drop_query = "DROP TYPE report_types"
    execute(create_query, drop_query)

    create_query =
      "CREATE TYPE category_types AS ENUM ('asset', 'liability', 'income', 'expense')"

    drop_query = "DROP TYPE category_types"
    execute(create_query, drop_query)

    create table(:report_categories) do
      add :code, :integer
      add :name, :string
      add :report_type, :report_types
      add :category_type, :category_types

      add :company_id, references(:companies)

      timestamps()
    end
  end
end
