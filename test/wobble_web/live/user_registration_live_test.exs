defmodule WobbleWeb.UserRegistrationLiveTest do
  use WobbleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Wobble.AccountsFixtures
  import Wobble.OrganisationsFixtures
  import Wobble.CompaniesFixtures

  defp logon(%{conn: conn}) do
    user = user_fixture()
    conn = log_in_user(conn, user)
    %{conn: conn, user: user}
  end

  def foo(%{conn: conn}) do
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

  def create_company() do
    user = user_fixture()
    %{company: company} = company_fixture(user.id, %{organisation_id: user.organisation_id})
    %{user: user, company: company}
  end

  describe "User Registration page" do
    setup [:foo]

    test "redirects if not logged in", %{conn: conn} do
      result =
        conn
        |> live(~p"/users/register")
        |> follow_redirect(conn, "/users/log_in")

      assert {:ok, _conn} = result
    end

    test "renders user registration page", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/register")

      assert html =~ "Create User"
      assert html =~ "Log out"
    end

    test "renders errors for invalid data", %{conn: conn} do
      {:ok, lv, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(user: %{"email" => "with spaces", "password" => "too short"})

      assert result =~ "Create User"
      assert result =~ "must have the @ sign and no spaces"
      assert result =~ "should be at least 12 character"
    end
  end

  describe "register user" do
    setup [:foo]

    test "creates account", %{conn: conn, user: user} do
      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/users/register")

      form =
        form(lv, "#registration_form",
          user: %{email: unique_user_email(), password: valid_user_password()}
        )

      render_submit(form)
      conn = follow_trigger_action(form, conn)

      assert redirected_to(conn) == ~p"/welcome"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ "Settings"
      assert response =~ "Log out"
    end

    test "renders errors for duplicated email", %{conn: conn, user: user} do
      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/users/register")

      user = user_fixture(%{email: "test@email.com"})

      lv
      |> form("#registration_form",
        user: %{"email" => user.email, "password" => "valid_password"}
      )
      |> render_submit() =~ "has already been taken"
    end

    test "creates account and adds to company", %{conn: conn, user: user, company: company} do
      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/users/register")

      user_email = unique_user_email()

      form =
        form(lv, "#registration_form",
          user: %{email: user_email, password: valid_user_password(), add_to_company: "true"}
        )

      render_submit(form)
      conn = follow_trigger_action(form, conn)

      assert redirected_to(conn) == ~p"/welcome"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ "Settings"
      assert response =~ "Log out"

      saved_user = Wobble.Accounts.get_user_by_email(user_email)
      company_user = Wobble.CompanyUsers.get_company_user_for_company!(saved_user.id, company.id)

      assert company_user.company_id == company.id
    end

    test "creates account and doesn not add to company", %{
      conn: conn,
      user: user,
      company: company
    } do
      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/users/register")

      user_email = unique_user_email()

      form =
        form(lv, "#registration_form",
          user: %{email: user_email, password: valid_user_password(), add_to_company: "false"}
        )

      render_submit(form)
      conn = follow_trigger_action(form, conn)

      assert redirected_to(conn) == ~p"/welcome"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ "Settings"
      assert response =~ "Log out"

      saved_user = Wobble.Accounts.get_user_by_email(user_email)

      assert_raise(
        Ecto.NoResultsError,
        fn ->
          Wobble.CompanyUsers.get_company_user_for_company!(saved_user.id, company.id)
        end)

    end
  end

  describe "user list page" do
    setup [:logon]

    test "lists all users for the organisation", %{conn: conn, user: organisation_user} do
      user = user_fixture(%{organisation_id: organisation_user.organisation_id})

      {:ok, _lv, html} =
        conn
        |> live(~p"/users")

      assert html =~ user.email
    end

    test "does not list users that do not belong to the organisation", %{conn: conn} do
      organisation2 = organisation_fixture(%{name: "Org 2"})
      user = user_fixture(%{organisation_id: organisation2.id})

      {:ok, _lv, html} =
        conn
        |> live(~p"/users")

      refute html =~ user.email
    end
  end
end
