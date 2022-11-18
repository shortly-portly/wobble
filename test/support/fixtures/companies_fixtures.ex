defmodule Wobble.CompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wobble.Companies` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        employees: 42,
        name: "some name"
      })
      |> Wobble.Companies.create_company()

    company
  end
end
