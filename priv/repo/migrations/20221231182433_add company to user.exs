defmodule :"Elixir.Wobble.Repo.Migrations.Add company to user" do
  use Ecto.Migration

  def change do

    alter table(:users) do
      add :company_id, :integer 
      add :company_name, :string
    end
  end
end
