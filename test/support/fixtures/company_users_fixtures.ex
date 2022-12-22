defmodule Wobble.CompanyUsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wobble.CompanyUsers` context.
  """

  import Wobble.AccountsFixtures
  import Wobble.CompaniesFixtures

  @doc """
  Generate a company_user.

  This uses the fact that creating a company automatically creates a company_user for the 
  given user.
  """
  def company_user_fixture(_attrs \\ %{}) do
    user = user_fixture() 
    %{company_user: company_user} = company_fixture(user.id, %{organisation_id: user.organisation_id}) 


    company_user
  end
end
