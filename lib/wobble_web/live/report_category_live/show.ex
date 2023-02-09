defmodule WobbleWeb.ReportCategoryLive.Show do
  use WobbleWeb, :live_view

  alias Wobble.ReportCategories

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:report_category, ReportCategories.get_report_category!(id))}
  end

  defp page_title(:show), do: "Show Report category"
  defp page_title(:edit), do: "Edit Report category"
end
