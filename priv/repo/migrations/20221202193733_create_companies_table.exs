defmodule Wobble.Repo.Migrations.CreateCompaniesTable do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :address_line_1, :string
      add :address_line_2, :string
      add :county, :string
      add :postcode, :string
      add :country, :string
      add :telephone, :string
      add :email, :string
      add :website, :string

      add :vat_registration_number, :string
      add :vat_country_code, :string
      add :next_vat_return_date, :date
      add :eori_number, :string

      add :organisation_id, references(:organisations)

      timestamps()
    end

    create unique_index(:companies, [:name, :organisation_id])
  end
end
