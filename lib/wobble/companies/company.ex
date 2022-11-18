defmodule Wobble.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :employees, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :employees])
    |> validate_required([:name, :employees])
  end
end
