defmodule WobbleWeb.NominalLive.Show do
  use WobbleWeb, :live_view

  alias Wobble.Nominals

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:nominal, Nominals.get_nominal!(id))}
  end

  defp page_title(:show), do: "Show Nominal"
  defp page_title(:edit), do: "Edit Nominal"
end
