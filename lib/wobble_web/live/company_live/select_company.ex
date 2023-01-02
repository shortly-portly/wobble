defmodule WobbleWeb.CompanyLive.SelectCompany do
  use WobbleWeb, :live_view

  alias Wobble.CompanyUsers

  def render(assigns) do
    ~H"""
    <.header>
      Select Company
    </.header>
    
    <.table id="companies" rows={@companies} row_click={&JS.push("select", value: %{id: &1.company.id})}>
      <:col :let={company} label="Name"><%= company.company.name %></:col>
      <:action :let={company}>
        <div class="sr-only">
          <.link navigate={~p"/companies/#{company}"}>Show</.link>
        </div>
        <.link patch={~p"/companies/#{company}/edit"}>Edit</.link>
      </:action>
      <:action :let={company}>
        <.link phx-click={JS.push("delete", value: %{id: company.id})} data-confirm="Are you sure?">
          Delete
        </.link>
      </:action>
    </.table>

    """
  end

  def mount(_params, _session, socket) do
    companies = CompanyUsers.list_companies_for_user(socket.assigns.current_user.id) 
    socket = assign(socket, :companies, companies)
    {:ok, socket}
  end


  def handle_event("select", %{"id" => company_id}, socket) do 
    # Don't trust the data - fetch the company user row for this user/company.
    company_user = CompanyUsers.get_company_user_for_company!(socket.assigns.current_user.id, company_id) 
    socket = assign(socket, :current_company, company_user.company_id)
    {:noreply, socket}
    end
end
