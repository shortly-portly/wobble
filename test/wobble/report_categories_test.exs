defmodule Wobble.ReportCategoriesTest do
  use Wobble.DataCase

  alias Wobble.ReportCategories

  import Wobble.AccountsFixtures
  import Wobble.CompaniesFixtures

  def create_company(_) do
    user = user_fixture()
    %{company: company} = company_fixture(user.id, %{organisation_id: user.organisation_id})
    %{company: company}
  end

  describe "report_categories" do
    setup [:create_company]
    alias Wobble.ReportCategories.ReportCategory

    import Wobble.ReportCategoriesFixtures

    @invalid_attrs %{code: nil, name: nil}

    test "list_report_categories/0 returns all report_categories", %{company: company} do
      report_category = report_category_fixture(%{company_id: company.id})
      assert ReportCategories.list_report_categories() == [report_category]
    end

    test "get_report_category!/1 returns the report_category with given id", %{company: company} do
      report_category = report_category_fixture(%{company_id: company.id})
      assert ReportCategories.get_report_category!(report_category.id) == report_category
    end

    test "create_report_category/1 with valid data creates a report_category", %{company: company} do
      valid_attrs = %{
        code: 42,
        name: "some name",
        report_type: :"profit and loss",
        category_type: :asset,
        company_id: company.id
      }

      assert {:ok, %ReportCategory{} = report_category} =
               ReportCategories.create_report_category(valid_attrs)

      assert report_category.code == 42
      assert report_category.name == "some name"
    end

    test "create_report_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ReportCategories.create_report_category(@invalid_attrs)
    end

    test "update_report_category/2 with valid data updates the report_category", %{company: company} do
      report_category = report_category_fixture(%{company_id: company.id})
      update_attrs = %{code: 43, name: "some updated name"}

      assert {:ok, %ReportCategory{} = report_category} =
               ReportCategories.update_report_category(report_category, update_attrs)

      assert report_category.code == 43
      assert report_category.name == "some updated name"
    end

    test "update_report_category/2 with invalid data returns error changeset", %{company: company} do
      report_category = report_category_fixture(%{company_id: company.id})

      assert {:error, %Ecto.Changeset{}} =
               ReportCategories.update_report_category(report_category, @invalid_attrs)

      assert report_category == ReportCategories.get_report_category!(report_category.id)
    end

    test "delete_report_category/1 deletes the report_category", %{company: company} do
      report_category = report_category_fixture(%{company_id: company.id})
      assert {:ok, %ReportCategory{}} = ReportCategories.delete_report_category(report_category)

      assert_raise Ecto.NoResultsError, fn ->
        ReportCategories.get_report_category!(report_category.id)
      end
    end

    test "change_report_category/1 returns a report_category changeset", %{company: company} do
      report_category = report_category_fixture(%{company_id: company.id})
      assert %Ecto.Changeset{} = ReportCategories.change_report_category(report_category)
    end
  end
end
