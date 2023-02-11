defmodule Wobble.ReportCategories.ReportCategory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "report_categories" do
    field :code, :integer
    field :name, :string
    field :report_type, Ecto.Enum, values: [:"profit and loss", :"balance sheet"]
    field :category_type, Ecto.Enum, values: [:asset, :liability, :income, :expense]

    belongs_to :company, Wobble.Companies.Company

    timestamps()
  end

  @valid_attrs [:code, :name, :report_type, :category_type, :company_id]

  @doc false
  def changeset(report_category, attrs) do
    report_category
    |> cast(attrs, @valid_attrs)
    |> validate_required(@valid_attrs)
    |> unsafe_validate_unique([:code, :company_id], Wobble.Repo)
    |> unique_constraint([:code, :company_id])
  end
end
