defmodule Wobble.Nominals.Nominal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "nominals" do
    field :balance, :integer
    field :code, :string
    field :name, :string

    belongs_to :company, Wobble.Companies.Company
    belongs_to :report_category, Wobble.ReportCategories.ReportCategory
    
    timestamps()
  end

  @doc false
  def changeset(nominal, attrs) do
    nominal
    |> cast(attrs, [:code, :name, :balance, :company_id, :report_category_id])
    |> validate_required([:code, :name, :balance, :company_id, :report_category_id])
    |> unique_constraint([:code, :company_id])
  end
end
