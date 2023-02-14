defmodule WobbleWeb.NominalLiveTest do
  use WobbleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Wobble.AccountsFixtures
  import Wobble.CompaniesFixtures
  import Wobble.ReportCategoriesFixtures
  import Wobble.NominalsFixtures

  @update_attrs %{balance: 43, code: "some updated code", name: "some updated name"}
  @invalid_attrs %{balance: nil, code: nil, name: nil}

  defp create_nominal(%{conn: conn}) do
    user = user_fixture()
    %{company: company} = company_fixture(user.id, %{organisation_id: user.organisation_id})
    report_category = report_category_fixture(%{company_id: company.id})
    nominal = nominal_fixture(company_id: company.id, report_category_id: report_category.id)

    conn =
      conn
      |> Plug.Test.init_test_session(
        current_company_id: company.id,
        current_company_name: company.name
      )

    %{conn: conn, user: user, company: company, report_category: report_category, nominal: nominal}
  end

  describe "Index" do
    setup [:create_nominal]

    test "lists all nominals", %{conn: conn, user: user, nominal: nominal} do

      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/nominals")

      assert html =~ "Listing Nominals"
      assert html =~ nominal.code
    end

    test "saves new nominal", %{conn: conn, user: user, report_category: report_category} do

      valid_attrs = %{
        balance: 42,
        code: "some code2",
        name: "some name",
        report_category_id: report_category.id
      }

      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/nominals")

      assert index_live |> element("a", "New Nominal") |> render_click() =~
               "New Nominal"

      assert_patch(index_live, ~p"/nominals/new")

      assert index_live
             |> form("#nominal-form", nominal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#nominal-form", nominal: valid_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/nominals")

      assert html =~ "Nominal created successfully"
      assert html =~ "some code"
    end

    test "updates nominal in listing", %{conn: conn, user: user, nominal: nominal} do

      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/nominals")

      assert index_live |> element("#nominals-#{nominal.id} a", "Edit") |> render_click() =~
               "Edit Nominal"

      assert_patch(index_live, ~p"/nominals/#{nominal}/edit")

      assert index_live
             |> form("#nominal-form", nominal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#nominal-form", nominal: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/nominals")

      assert html =~ "Nominal updated successfully"
      assert html =~ "some updated code"
    end

    test "deletes nominal in listing", %{conn: conn, user: user, nominal: nominal} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/nominals")

      assert index_live |> element("#nominals-#{nominal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#nominal-#{nominal.id}")
    end
  end

  describe "Show" do
    setup [:create_nominal]

    test "displays nominal", %{conn: conn, user: user, nominal: nominal} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/nominals/#{nominal}")

      assert html =~ "Show Nominal"
      assert html =~ nominal.code
    end

    test "updates nominal within modal", %{conn: conn, user: user, nominal: nominal} do
      conn = log_in_user(conn, user)
      {:ok, show_live, _html} = live(conn, ~p"/nominals/#{nominal}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Nominal"

      assert_patch(show_live, ~p"/nominals/#{nominal}/show/edit")

      assert show_live
             |> form("#nominal-form", nominal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#nominal-form", nominal: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/nominals/#{nominal}")

      assert html =~ "Nominal updated successfully"
      assert html =~ "some updated code"
    end
  end
end
