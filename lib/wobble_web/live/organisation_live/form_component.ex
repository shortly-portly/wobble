defmodule WobbleWeb.OrganisationLive.FormComponent do
  use WobbleWeb, :live_component

  alias Wobble.Organisations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage organisation records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="organisation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Organisation</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{organisation: organisation} = assigns, socket) do
    changeset = Organisations.change_organisation(organisation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"organisation" => organisation_params}, socket) do
    changeset =
      socket.assigns.organisation
      |> Organisations.change_organisation(organisation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"organisation" => organisation_params}, socket) do
    save_organisation(socket, socket.assigns.action, organisation_params)
  end

  defp save_organisation(socket, :edit, organisation_params) do
    case Organisations.update_organisation(socket.assigns.organisation, organisation_params) do
      {:ok, _organisation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organisation updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_organisation(socket, :new, organisation_params) do
    case Organisations.create_organisation(organisation_params) do
      {:ok, _organisation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organisation created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
