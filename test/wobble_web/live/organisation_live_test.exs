defmodule WobbleWeb.OrganisationLiveTest do
  use WobbleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Wobble.OrganisationsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_organisation(_) do
    organisation = organisation_fixture()
    %{organisation: organisation}
  end

  describe "Index" do
    setup [:create_organisation]

    test "lists all organisation", %{conn: conn, organisation: organisation} do
      {:ok, _index_live, html} = live(conn, ~p"/organisation")

      assert html =~ "Listing Organisation"
      assert html =~ organisation.name
    end

    test "saves new organisation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/organisation")

      assert index_live |> element("a", "New Organisation") |> render_click() =~
               "New Organisation"

      assert_patch(index_live, ~p"/organisation/new")

      assert index_live
             |> form("#organisation-form", organisation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#organisation-form", organisation: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/organisation")

      assert html =~ "Organisation created successfully"
      assert html =~ "some name"
    end

    test "updates organisation in listing", %{conn: conn, organisation: organisation} do
      {:ok, index_live, _html} = live(conn, ~p"/organisation")

      assert index_live |> element("#organisation-#{organisation.id} a", "Edit") |> render_click() =~
               "Edit Organisation"

      assert_patch(index_live, ~p"/organisation/#{organisation}/edit")

      assert index_live
             |> form("#organisation-form", organisation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#organisation-form", organisation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/organisation")

      assert html =~ "Organisation updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes organisation in listing", %{conn: conn, organisation: organisation} do
      {:ok, index_live, _html} = live(conn, ~p"/organisation")

      assert index_live |> element("#organisation-#{organisation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#organisation-#{organisation.id}")
    end
  end

  describe "Show" do
    setup [:create_organisation]

    test "displays organisation", %{conn: conn, organisation: organisation} do
      {:ok, _show_live, html} = live(conn, ~p"/organisation/#{organisation}")

      assert html =~ "Show Organisation"
      assert html =~ organisation.name
    end

    test "updates organisation within modal", %{conn: conn, organisation: organisation} do
      {:ok, show_live, _html} = live(conn, ~p"/organisation/#{organisation}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Organisation"

      assert_patch(show_live, ~p"/organisation/#{organisation}/show/edit")

      assert show_live
             |> form("#organisation-form", organisation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#organisation-form", organisation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/organisation/#{organisation}")

      assert html =~ "Organisation updated successfully"
      assert html =~ "some updated name"
    end
  end
end
