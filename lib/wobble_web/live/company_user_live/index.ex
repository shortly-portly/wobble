defmodule WobbleWeb.CompanyUserLive.Index do
  use WobbleWeb, :live_view

  alias Wobble.Accounts
  alias Wobble.CompanyUsers
  alias Wobble.CompanyUsers.CompanyUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok, build_user_lists(socket)}
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

    {:noreply, build_user_lists(socket)}
  end

  def handle_event("add_user", %{"id" => id}, socket) do
    {:ok, _} =
      CompanyUsers.create_company_user(%{
        user_id: id,
        company_id: socket.assigns.current_company_id
      })


    {:noreply, build_user_lists(socket)}
  end

  def handle_event("remove_user", %{"id" => id}, socket) do
    # Ensure we have at least one user
    if Enum.count(socket.assigns.allocated_users) > 1 do

      company_user = CompanyUsers.get_company_user_for_company!(id, socket.assigns.current_company_id)
      {:ok, _} = CompanyUsers.delete_company_user(company_user)
      {:noreply, build_user_lists(socket)}
    else
      {:noreply,
       build_user_lists(socket |> put_flash(:error, "A company must have at least one allocated user."))}
    end
  end

  defp build_user_lists(socket) do
    allocated_users = list_users_for_company(socket.assigns.current_company_id)

    unallocated_users =
      list_unassigned_users(socket.assigns.current_user.organisation_id, allocated_users)

    socket
    |> assign(:allocated_users, allocated_users)
    |> assign(:unallocated_users, unallocated_users)
  end

  defp list_users_for_company(company_id) do
    CompanyUsers.list_users_for_company(company_id)
  end

  defp list_unassigned_users(organisation_id, allocated_users) do
    exclude_users = Enum.map(allocated_users, fn u -> u.id end)
    Accounts.list_unassigned_users(organisation_id, exclude_users)
  end
end
