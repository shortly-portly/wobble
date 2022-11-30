defmodule WobbleWeb.UserListLive do
  use WobbleWeb, :live_view

  alias Wobble.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Users
      <:actions>
        <.link patch={~p"/users/register"}>
          <.button>New User</.button>
        </.link>
      </:actions>
    </.header>

    <.table id="users" rows={@users} row_click={&JS.navigate(~p"/companies/#{&1}")}>
      <:col :let={user} label="Email"><%= user.email %></:col>
    </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :users, list_users(socket.assigns.current_user.organisation_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:company, nil)
  end

  defp list_users(organisation_id) do
    Accounts.list_users(organisation_id)
  end
end
