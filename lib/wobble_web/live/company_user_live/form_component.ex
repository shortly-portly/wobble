defmodule WobbleWeb.CompanyUserLive.FormComponent do
  use WobbleWeb, :live_component

  alias Wobble.CompanyUsers

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage company_user records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="company_user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Company user</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{company_user: company_user} = assigns, socket) do
    changeset = CompanyUsers.change_company_user(company_user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"company_user" => company_user_params}, socket) do
    changeset =
      socket.assigns.company_user
      |> CompanyUsers.change_company_user(company_user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"company_user" => company_user_params}, socket) do
    save_company_user(socket, socket.assigns.action, company_user_params)
  end

  defp save_company_user(socket, :edit, company_user_params) do
    case CompanyUsers.update_company_user(socket.assigns.company_user, company_user_params) do
      {:ok, _company_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Company user updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_company_user(socket, :new, company_user_params) do
    case CompanyUsers.create_company_user(company_user_params) do
      {:ok, _company_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Company user created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
