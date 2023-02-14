defmodule WobbleWeb.NominalLive.Index do
  use WobbleWeb, :live_view

  alias Wobble.Nominals
  alias Wobble.Nominals.Nominal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :nominals, list_nominals())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Nominal")
    |> assign(:nominal, Nominals.get_nominal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Nominal")
    |> assign(:nominal, %Nominal{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Nominals")
    |> assign(:nominal, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    nominal = Nominals.get_nominal!(id)
    {:ok, _} = Nominals.delete_nominal(nominal)

    {:noreply, assign(socket, :nominals, list_nominals())}
  end

  defp list_nominals do
    Nominals.list_nominals()
  end
end
