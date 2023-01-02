defmodule Wobble.Swamps.Dead do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dead" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(dead, attrs) do
    dead
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
