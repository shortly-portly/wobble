defmodule WobbleWeb.CompanyUserLive.Show do
  use WobbleWeb, :live_view

  alias Wobble.CompanyUsers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:company_user, CompanyUsers.get_company_user!(id))}
  end

  defp page_title(:show), do: "Show Company user"
  defp page_title(:edit), do: "Edit Company user"
end
