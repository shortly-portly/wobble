defmodule WobbleWeb.ReportCategoryLive.FormComponent do
  use WobbleWeb, :live_component

  alias Wobble.ReportCategories

  @report_types [
    {"Profit and Loss", :"profit and loss"},
    {"Balance Sheet", :"balance sheet"}
  ]
  @pl_categories [
    {"Income", :income},
    {"Expense", :expense}
  ]

  @bs_categories [
    [value: :asset, key: "Asset"],
    [value: :liability, key: "Liability"]
  ]

  @impl true

  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage report_category records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="report_category-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :code}} type="number" label="code" />
        <.input field={{f, :name}} type="text" label="name" />
        <.input field={{f, :report_type}} type="select" label="report type" options={@report_types} />
        <.input
          field={{f, :category_type}}
          type="select"
          label="category type"
          options={@category_types}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Report category</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{report_category: report_category} = assigns, socket) do
    changeset = ReportCategories.change_report_category(report_category)
    
    {_, report_type} = Ecto.Changeset.fetch_field(changeset, :report_type)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:report_types, @report_types)
     |> assign(:category_types, set_category_types(report_type))
    }
  end

  @impl true
  def handle_event("validate", %{"report_category" => report_category_params}, socket) do
    changeset =
      socket.assigns.report_category
      |> ReportCategories.change_report_category(report_category_params)
      |> Map.put(:action, :validate)

    {_, report_type} = Ecto.Changeset.fetch_field(changeset, :report_type)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:category_types, set_category_types(report_type))}
  end

  def handle_event("save", %{"report_category" => report_category_params}, socket) do
    save_report_category(socket, socket.assigns.action, report_category_params)
  end

  defp save_report_category(socket, :edit, report_category_params) do
    case ReportCategories.update_report_category(
           socket.assigns.report_category,
           report_category_params
         ) do
      {:ok, _report_category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Report category updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_report_category(socket, :new, report_category_params) do
    company_id = socket.assigns.current_company_id
    report_category_params = Map.put(report_category_params, "company_id", company_id)

    case ReportCategories.create_report_category(report_category_params) do
      {:ok, _report_category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Report category created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp set_category_types(report_type) do
    case report_type do
      :"profit and loss" -> @pl_categories
      :"balance sheet" -> @bs_categories
    end
  end
end
