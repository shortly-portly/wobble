defmodule WobbleWeb.CompanyUserLiveTest do
  use WobbleWeb.ConnCase

  alias Wobble.CompanyUsers

  import Phoenix.LiveViewTest
  import Wobble.AccountsFixtures
  import Wobble.CompaniesFixtures

  def user_with_company(%{conn: conn}) do
    user = user_fixture()
    %{company: company} = company_fixture(user.id, %{organisation_id: user.organisation_id})

    conn =
      conn
      |> Plug.Test.init_test_session(
        current_company_id: company.id,
        current_company_name: company.name
      )

    %{conn: conn, user: user, company: company}
  end

  describe "add user to company" do
    setup [:user_with_company]

    test "creates a company user record", %{conn: conn, user: user} do
      user2 = user_fixture(%{organisation_id: user.organisation_id})

      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/company_users")

      element(lv, "#add-#{user2.id}") |> render_click()
      assert element(lv, "#allocated_users-#{user2.id}") |> render() =~ user2.email
    end
  end

  describe "remove user to company" do
    setup [:user_with_company]

    test "deletes a company user record", %{conn: conn, user: user, company: company} do
      user2 = user_fixture(%{organisation_id: user.organisation_id})
      {:ok, _company_user} = CompanyUsers.create_company_user(%{user_id: user2.id, company_id: company.id})

      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/company_users")

      element(lv, "#remove-#{user2.id}") |> render_click()
      assert element(lv, "#unallocated_users-#{user2.id}") |> render() =~ user2.email
    end

    test "won't delete if only has one user", %{conn: conn, user: user} do

      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/company_users")

      element(lv, "#remove-#{user.id}") |> render_click()
      assert element(lv, "#allocated_users-#{user.id}") |> render() =~ user.email

      assert element(lv, ".flash-error") |> render() =~ "A company must have at least one allocated user"
    end
  end
end
