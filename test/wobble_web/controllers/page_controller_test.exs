defmodule WobbleWeb.PageControllerTest do
  use WobbleWeb.ConnCase

  import Wobble.AccountsFixtures

  test "GET /", %{conn: conn} do
    conn =
      conn
      |> log_in_user(user_fixture())
      |> get(~p"/")

    assert html_response(conn, 200) =~ "Welcome"
  end
end
