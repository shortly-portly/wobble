defmodule WobbleWeb.NominalLive.FormComponent do
  use WobbleWeb, :live_component

  alias Wobble.Nominals
  alias Wobble.ReportCategories

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage nominal records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="nominal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :code}} type="text" label="code" />
        <.input field={{f, :name}} type="text" label="name" />
        <.input field={{f, :balance}} type="number" label="balance" />
        <.live_component
          module={WobbleWeb.RepCatSelect}
          id="woobar"
          field={{f, :report_category_id}}
          label="Report Category"
          current_company_id={@current_company_id}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Nominal</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{nominal: nominal} = assigns, socket) do
    changeset = Nominals.change_nominal(nominal)

    report_categories =
      ReportCategories.select_report_categories(assigns.current_company_id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:report_categories, report_categories)}
  end

  @impl true
  def handle_event("validate", %{"nominal" => nominal_params}, socket) do
    changeset =
      socket.assigns.nominal
      |> Nominals.change_nominal(nominal_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"nominal" => nominal_params}, socket) do
    save_nominal(socket, socket.assigns.action, nominal_params)
  end

  defp save_nominal(socket, :edit, nominal_params) do
    case Nominals.update_nominal(socket.assigns.nominal, nominal_params) do
      {:ok, _nominal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Nominal updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_nominal(socket, :new, nominal_params) do
    company_id = socket.assigns.current_company_id
    nominal_params = Map.put(nominal_params, "company_id", company_id)

    case Nominals.create_nominal(nominal_params) do
      {:ok, _nominal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Nominal created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
