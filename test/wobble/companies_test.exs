defmodule Wobble.CompaniesTest do
  use Wobble.DataCase

  alias Wobble.Companies

  describe "companies" do
    alias Wobble.Companies.Company

    import Wobble.CompaniesFixtures
    import Wobble.AccountsFixtures

    @invalid_attrs %{name: nil}

    test "list_companies/0 returns all companies" do
      user = user_fixture()
      company = company_fixture(%{organisation_id: user.organisation_id})
      assert Companies.list_companies(user.organisation_id) == [company]
    end

    test "get_company!/1 returns the company with given id" do
      user = user_fixture()
      company = company_fixture(%{organisation_id: user.organisation_id})
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      user = user_fixture()
      valid_attrs = %{name: "some name", organisation_id: user.organisation_id}

      assert {:ok, %Company{} = company} = Companies.create_company(valid_attrs)
      assert company.name == "some name"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      user = user_fixture()
      company = company_fixture(%{organisation_id: user.organisation_id})
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Company{} = company} = Companies.update_company(company, update_attrs)
      assert company.name == "some updated name"
    end

    test "update_company/2 with invalid data returns error changeset" do
      user = user_fixture()
      company = company_fixture(%{organisation_id: user.organisation_id})
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      user = user_fixture()
      company = company_fixture(%{organisation_id: user.organisation_id})
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      user = user_fixture()
      company = company_fixture(%{organisation_id: user.organisation_id})
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end

    test "list_companies/1 only returns companies for organisation_id" do
      user1 = user_fixture()
      company1a = company_fixture(%{organisation_id: user1.organisation_id})
      company1b = company_fixture(%{name: "company1b", organisation_id: user1.organisation_id})

      user2 = user_fixture()
      company2 = company_fixture(%{organisation_id: user2.organisation_id})

      assert Companies.list_companies(user1.organisation_id) == [company1a, company1b]
      refute Companies.list_companies(user1.organisation_id) == [company2]
    end
  end
end
