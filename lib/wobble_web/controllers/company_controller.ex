defmodule WobbleWeb.CompanyController do
  use WobbleWeb, :controller

  alias Wobble.Accounts.User
  alias Wobble.CompanyUsers
  alias Wobble.CompanyUsers.CompanyUser
  alias Wobble.Repo

  def index(conn, _params) do
    companies = CompanyUsers.list_companies_for_user(conn.assigns.current_user.id)
    changeset = CompanyUsers.change_company_user(%CompanyUser{})

    render(conn, :index, companies: companies, changeset: changeset)
  end

  def update(conn, %{"company_user" => company_user}) do
    attrs = %{company_id: company_user["company_id"]}
    user = conn.assigns.current_user

    user
    |> User.company_changeset(attrs)
    |> Repo.update()
    |> dbg()

    redirect(conn, to: ~p"/")
  end

  def update(conn, _params) do
    conn
    |> put_flash(:error, "Please select a company.")
    |> redirect(to: ~p"/companies/select_company")
  end
end
