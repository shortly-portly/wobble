defmodule Wobble.CompanyUsersTest do
  use Wobble.DataCase

  alias Wobble.CompanyUsers

  import Wobble.AccountsFixtures
  import Wobble.CompaniesFixtures

  describe "company_users" do
    alias Wobble.CompanyUsers.CompanyUser

    import Wobble.CompanyUsersFixtures

    test "list_company_users/0 returns all company_users" do
      company_user = company_user_fixture()
      assert CompanyUsers.list_company_users() == [company_user]
    end

    test "get_company_user!/1 returns the company_user with given id" do
      company_user = company_user_fixture()
      assert CompanyUsers.get_company_user!(company_user.id) == company_user
    end

    test "create_company_user/1 with valid data creates a company_user" do
      user = user_fixture()

      %{company: company} = company_fixture(user.id, %{organisation_id: user.organisation_id})
      user2 = user_fixture()
      valid_attrs = %{user_id: user2.id, company_id: company.id}
      assert {:ok, %CompanyUser{} = company_user} = CompanyUsers.create_company_user(valid_attrs)
      assert company_user.user_id == user2.id
    end

    # test "create_company_user/1 with invalid data returns error changeset" do
    # assert {:error, %Ecto.Changeset{}} = CompanyUsers.create_company_user(@invalid_attrs)
    # end

    # test "update_company_user/2 with valid data updates the company_user" do
    # company_user = company_user_fixture()
    # update_attrs = %{name: "some updated name"}

    # assert {:ok, %CompanyUser{} = company_user} = CompanyUsers.update_company_user(company_user, update_attrs)
    # assert company_user.name == "some updated name"
    # end

    # test "update_company_user/2 with invalid data returns error changeset" do
    # company_user = company_user_fixture()
    # assert {:error, %Ecto.Changeset{}} = CompanyUsers.update_company_user(company_user, @invalid_attrs)
    # assert company_user == CompanyUsers.get_company_user!(company_user.id)
    # end

    # test "delete_company_user/1 deletes the company_user" do
    # company_user = company_user_fixture()
    # assert {:ok, %CompanyUser{}} = CompanyUsers.delete_company_user(company_user)
    # assert_raise Ecto.NoResultsError, fn -> CompanyUsers.get_company_user!(company_user.id) end
    # end

    # test "change_company_user/1 returns a company_user changeset" do
    # company_user = company_user_fixture()
    # assert %Ecto.Changeset{} = CompanyUsers.change_company_user(company_user)
    # end
  end
end
