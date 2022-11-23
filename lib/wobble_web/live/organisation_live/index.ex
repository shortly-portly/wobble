defmodule WobbleWeb.OrganisationLive.Index do
  use WobbleWeb, :live_view

  alias Wobble.Organisations
  alias Wobble.Organisations.Organisation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :organisation_collection, list_organisation())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Organisation")
    |> assign(:organisation, Organisations.get_organisation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Organisation")
    |> assign(:organisation, %Organisation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Organisation")
    |> assign(:organisation, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    organisation = Organisations.get_organisation!(id)
    {:ok, _} = Organisations.delete_organisation(organisation)

    {:noreply, assign(socket, :organisation_collection, list_organisation())}
  end

  defp list_organisation do
    Organisations.list_organisation()
  end
end
