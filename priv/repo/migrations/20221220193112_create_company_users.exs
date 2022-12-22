defmodule Wobble.Repo.Migrations.CreateCompanyUsers do
  use Ecto.Migration

  def change do
    create table(:company_users) do
      add :company_id, references(:companies, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

  end
end
