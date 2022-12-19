defmodule WobbleWeb.CompanyLive.FormComponent do
  use WobbleWeb, :live_component

  alias Wobble.Companies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage company records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="company-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.alert :if={@changeset.action == :insert} /> 

        <div class="flex">
          <div class="w-1/2 flex flex-col border-2 mb-2 mr-2 pb-8 px-8 py-8">
            <.form_section title="Company Details">
              <.input field={{f, :name}} type="text" label="name" />
              <.input field={{f, :address_line_1}} type="text" label="Address" />
              <.input field={{f, :address_line_2}} type="text" />
              <.input field={{f, :county}} type="text" label="County" />
              <.input field={{f, :postcode}} type="text" label="Postcode" />
              <.input field={{f, :country}} type="text" label="Country" />
            </.form_section>
            <.form_section title="Contact Details">
              <.input field={{f, :telephone}} type="text" label="Telephone" />
              <.input field={{f, :email}} type="text" label="Email" />
              <.input field={{f, :website}} type="text" label="website" />
            </.form_section>
          </div>
          <div class="w-1/2 flex flex-col border-2 mb-2 mr-2 pb-8 px-8 py-8">
            <.form_section title="VAT Details">
              <.input
                field={{f, :vat_registration_number}}
                type="text"
                label="VAT Registration Number"
              />
              <.input field={{f, :vat_country_code}} type="text" label="VAT Country Code" />
              <.input field={{f, :next_vat_return_date}} type="text" label="Next VAT Return Date" />
              <.input field={{f, :eori_number}} type="text" label="EORI Number" />
            </.form_section>
          </div>
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Company</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{company: company} = assigns, socket) do
    changeset = Companies.change_company(company)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"company" => company_params}, socket) do
    changeset =
      socket.assigns.company
      |> Companies.change_company(company_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"company" => company_params}, socket) do
    save_company(socket, socket.assigns.action, company_params)
  end

  defp save_company(socket, :edit, company_params) do
    case Companies.update_company(socket.assigns.company, company_params) do
      {:ok, _company} ->
        {:noreply,
         socket
         |> put_flash(:info, "Company updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_company(socket, :new, company_params) do
    company_params =
      Map.put(company_params, "organisation_id", socket.assigns.current_user.organisation_id)

    case Companies.create_company(company_params) do
      {:ok, _company} ->
        {:noreply,
         socket
         |> put_flash(:info, "Company created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Oops something went wrong!")
         |> assign(changeset: changeset)}
    end
  end
end
