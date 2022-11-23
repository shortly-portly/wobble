defmodule Wobble.Organisations.Organisation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organisations" do
    field :name, :string

    has_many(:users, Wobble.Accounts.User, on_delete: :delete_all)

    timestamps()
  end

  def changeset(organisation, attrs) do
    organisation
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
