defmodule Wobble.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Wobble.Repo

  alias Wobble.Companies.Company
  alias Wobble.CompanyUsers 
  @doc """
  Returns the list of companies associated with the given organisation id.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies(organisation_id) do
    from(
      c in Company,
      where: c.organisation_id == ^organisation_id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a company.

  This is a mutli stage process.
  * Create the company
  * Add the user who created the company to the company_user table (which controls access to the
  newly created company).

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(user_id, attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:company, Company.changeset(%Company{}, attrs))
    |> Multi.run(:company_user, &create_company_user(&1, &2, user_id))
    |> Repo.transaction()
  end

  def create_company_user(_changes, %{company: company}, user_id) do

    CompanyUsers.create_company_user(%{
      user_id: user_id,
      company_id: company.id
    })
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end
end
