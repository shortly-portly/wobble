defmodule Wobble.NominalsTest do
  use Wobble.DataCase

  alias Wobble.Nominals

  import Wobble.AccountsFixtures
  import Wobble.CompaniesFixtures
  import Wobble.NominalsFixtures
  import Wobble.ReportCategoriesFixtures

  def create_nominal(_) do
    user = user_fixture()
    %{company: company} = company_fixture(user.id, %{organisation_id: user.organisation_id})
    report_category = report_category_fixture(company_id: company.id)
    nominal = nominal_fixture(company_id: company.id, report_category_id: report_category.id)

    %{nominal: nominal, company: company, report_category: report_category}
  end

  describe "nominals" do
    setup [:create_nominal]
    alias Wobble.Nominals.Nominal

    import Wobble.NominalsFixtures

    @invalid_attrs %{balance: nil, code: nil, name: nil}

    test "list_nominals/0 returns all nominals", %{nominal: nominal} do
      assert Nominals.list_nominals() == [nominal]
    end

    test "get_nominal!/1 returns the nominal with given id", %{nominal: nominal} do
      assert Nominals.get_nominal!(nominal.id) == nominal
    end

    test "create_nominal/1 with valid data creates a nominal", %{
      company: company,
      report_category: report_category
    } do
      valid_attrs = %{
        balance: 42,
        code: "some code2",
        name: "some name",
        company_id: company.id,
        report_category_id: report_category.id
      }

      assert {:ok, %Nominal{} = nominal} = Nominals.create_nominal(valid_attrs)
      assert nominal.balance == 42
      assert nominal.code == "some code2"
      assert nominal.name == "some name"
    end

    test "create_nominal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Nominals.create_nominal(@invalid_attrs)
    end

    test "update_nominal/2 with valid data updates the nominal", %{nominal: nominal} do
      update_attrs = %{balance: 43, code: "some updated code", name: "some updated name"}

      assert {:ok, %Nominal{} = nominal} = Nominals.update_nominal(nominal, update_attrs)
      assert nominal.balance == 43
      assert nominal.code == "some updated code"
      assert nominal.name == "some updated name"
    end

    test "update_nominal/2 with invalid data returns error changeset", %{nominal: nominal} do
      assert {:error, %Ecto.Changeset{}} = Nominals.update_nominal(nominal, @invalid_attrs)
      assert nominal == Nominals.get_nominal!(nominal.id)
    end

    test "delete_nominal/1 deletes the nominal", %{nominal: nominal} do
      assert {:ok, %Nominal{}} = Nominals.delete_nominal(nominal)
      assert_raise Ecto.NoResultsError, fn -> Nominals.get_nominal!(nominal.id) end
    end

    test "change_nominal/1 returns a nominal changeset", %{nominal: nominal} do
      assert %Ecto.Changeset{} = Nominals.change_nominal(nominal)
    end
  end
end
