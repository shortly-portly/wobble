defmodule Wobble.CompanyUsers.CompanyUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "company_users" do
    belongs_to :company, Wobble.Companies.Company
    belongs_to :user, Wobble.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(company_user, attrs) do
    company_user
    |> cast(attrs, [:company_id, :user_id])
    |> validate_required([:company_id, :user_id])
  end
end
