defmodule WobbleWeb.CompanyController do
  use WobbleWeb, :controller

  alias Wobble.CompanyUsers
  alias Wobble.CompanyUsers.CompanyUser

  def index(conn, _params) do
    companies = CompanyUsers.list_companies_for_user(conn.assigns.current_user.id)
    changeset = CompanyUsers.change_company_user(%CompanyUser{})

    render(conn, :index, companies: companies, changeset: changeset)
  end

  def update(conn, %{"company_user" => company_user}) do
    user = conn.assigns.current_user

    company_id = String.to_integer(company_user["company_id"])
    company_user = CompanyUsers.get_company_user_for_company!(user.id, company_id)
    user_return_to = get_session(conn, :user_return_to)

    conn
    |> put_session(:current_company_name, company_user.company.name)
    |> put_session(:current_company_id, company_user.company_id)
    |> redirect(to: user_return_to || ~p"/")
  end

  def update(conn, _params) do
    conn
    |> put_flash(:error, "Please select a company.")
    |> redirect(to: ~p"/companies/select_company")
  end
end
