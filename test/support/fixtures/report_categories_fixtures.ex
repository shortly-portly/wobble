defmodule Wobble.ReportCategoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wobble.ReportCategories` context.
  """

  @doc """
  Generate a report_category.
  """
  def report_category_fixture(attrs \\ %{}) do
    {:ok, report_category} =
      attrs
      |> Enum.into(%{
        code: 42,
        name: "some name",
        report_type: :"profit and loss",
        category_type: :asset
      })
    
      |> Wobble.ReportCategories.create_report_category()

    report_category
  end
end
