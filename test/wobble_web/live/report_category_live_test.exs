defmodule WobbleWeb.ReportCategoryLiveTest do
  use WobbleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Wobble.AccountsFixtures
  import Wobble.CompaniesFixtures
  import Wobble.ReportCategoriesFixtures

  @create_attrs %{
    code: 42,
    name: "some name",
    report_type: :"profit and loss",
    category_type: :asset
  }
  @update_attrs %{code: 43, name: "some updated name"}
  @invalid_attrs %{code: nil, name: nil}

  def create_report_category(%{conn: conn}) do
    user = user_fixture()
    %{company: company} = company_fixture(user.id, %{organisation_id: user.organisation_id})
    report_category = report_category_fixture(%{company_id: company.id})

    conn =
      conn
      |> Plug.Test.init_test_session(
        current_company_id: company.id,
        current_company_name: company.name
      )

    %{conn: conn, user: user, company: company, report_category: report_category}
  end

  describe "Index" do
    setup [:create_report_category]

    test "lists all report_categories", %{
      conn: conn,
      user: user,
      report_category: report_category
    } do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/report_categories")

      assert html =~ "Listing Report categories"
      assert html =~ report_category.name
    end

    test "saves new report_category", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)

      {:ok, index_live, _html} =
        conn
        |> live(~p"/report_categories")

      assert index_live |> element("a", "New Report category") |> render_click() =~
               "New Report category"

      assert_patch(index_live, ~p"/report_categories/new")

      assert index_live
             |> form("#report_category-form", report_category: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#report_category-form", report_category: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/report_categories")

      assert html =~ "Report category created successfully"
      assert html =~ "some name"
    end

    test "updates report_category in listing", %{conn: conn, user: user, report_category: report_category} do
      conn = log_in_user(conn, user)

      {:ok, index_live, _html} =
        conn
        |> live(~p"/report_categories")

      assert index_live
             |> element("#report_categories-#{report_category.id} a", "Edit")
             |> render_click() =~
               "Edit Report category"

      assert_patch(index_live, ~p"/report_categories/#{report_category}/edit")

      assert index_live
             |> form("#report_category-form", report_category: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#report_category-form", report_category: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/report_categories")

      assert html =~ "Report category updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes report_category in listing", %{conn: conn, user: user, report_category: report_category} do

      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/report_categories")

      assert index_live
             |> element("#report_categories-#{report_category.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#report_category-#{report_category.id}")
    end
  end

  describe "Show" do
    setup [:create_report_category]

    test "displays report_category", %{conn: conn, user: user, report_category: report_category} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/report_categories/#{report_category}")

      assert html =~ "Show Report category"
      assert html =~ report_category.name
    end

    test "updates report_category within modal", %{conn: conn, user: user, report_category: report_category} do
      conn = log_in_user(conn, user)
      
      {:ok, show_live, _html} =
        conn
        |> live(~p"/report_categories/#{report_category}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Report category"

      assert_patch(show_live, ~p"/report_categories/#{report_category}/show/edit")

      assert show_live
             |> form("#report_category-form", report_category: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#report_category-form", report_category: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/report_categories/#{report_category}")

      assert html =~ "Report category updated successfully"
      assert html =~ "some updated name"
    end
  end
end
