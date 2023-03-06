defmodule Wobble.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :date, :date
    field :name, :string

    belongs_to :company, Wobble.Companies.Company
    has_many :movements, Wobble.Movements.Movement

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:name, :date])
    |> validate_required([:name, :date])
  end
end
