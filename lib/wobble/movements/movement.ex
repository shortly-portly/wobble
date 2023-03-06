defmodule Wobble.Movements.Movement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movements" do
    field :amount, :integer
    field :description, :string

    belongs_to :nominal, Wobble.Nominals.Nominal
    belongs_to :transaction, Wobble.Transactions.Transaction

    timestamps()
  end

  @doc false
  def changeset(movement, attrs) do
    movement
    |> cast(attrs, [:description, :amount])
    |> validate_required([:description, :amount])
  end
end
