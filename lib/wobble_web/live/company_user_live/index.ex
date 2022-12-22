defmodule WobbleWeb.CompanyUserLive.Index do
  use WobbleWeb, :live_view

  alias Wobble.CompanyUsers
  alias Wobble.CompanyUsers.CompanyUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :company_users, list_company_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Company user")
    |> assign(:company_user, CompanyUsers.get_company_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Company user")
    |> assign(:company_user, %CompanyUser{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Company users")
    |> assign(:company_user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    company_user = CompanyUsers.get_company_user!(id)
    {:ok, _} = CompanyUsers.delete_company_user(company_user)

    {:noreply, assign(socket, :company_users, list_company_users())}
  end

  defp list_company_users do
    CompanyUsers.list_company_users()
  end
end
