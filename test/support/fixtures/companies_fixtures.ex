defmodule Wobble.CompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wobble.Companies` context.
  """

  @doc """
  Generate a company.

  The process of generating a company also adds the user (provided by `user_id`) to the list of
  of users who can access the company. Hence `create_company` returns both the company and the 
  company_user record.
  """
  def company_fixture(user_id, attrs \\ %{}) do
    {:ok, multi} =
      Wobble.Companies.create_company(
        user_id,
        attrs
        |> Enum.into(%{
          name: "some name"
        })
      )

    multi
  end
end
