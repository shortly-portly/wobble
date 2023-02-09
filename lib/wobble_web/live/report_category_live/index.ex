defmodule WobbleWeb.ReportCategoryLive.Index do
  use WobbleWeb, :live_view

  alias Wobble.ReportCategories
  alias Wobble.ReportCategories.ReportCategory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :report_categories, list_report_categories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Report category")
    |> assign(:report_category, ReportCategories.get_report_category!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Report category")
    |> assign(:report_category, %ReportCategory{report_type: :"balance sheet", category_type: :asset})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Report categories")
    |> assign(:report_category, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    report_category = ReportCategories.get_report_category!(id)
    {:ok, _} = ReportCategories.delete_report_category(report_category)

    {:noreply, assign(socket, :report_categories, list_report_categories())}
  end

  defp list_report_categories do
    ReportCategories.list_report_categories()
  end
end
