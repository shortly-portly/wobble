defmodule Wobble.CompanyUsers do
  @moduledoc """
  The CompanyUsers context.
  """

  import Ecto.Query, warn: false
  alias Wobble.Repo

  alias Wobble.CompanyUsers.CompanyUser

  @doc """
  Returns the list of company_users.

  ## Examples

      iex> list_company_users()
      [%CompanyUser{}, ...]

  """
  def list_company_users do
    Repo.all(CompanyUser)
  end

  @doc """
  Gets a single company_user.

  Raises `Ecto.NoResultsError` if the Company user does not exist.

  ## Examples

      iex> get_company_user!(123)
      %CompanyUser{}

      iex> get_company_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company_user!(id), do: Repo.get!(CompanyUser, id)

  @doc """
  Creates a company_user.

  ## Examples

      iex> create_company_user(%{field: value})
      {:ok, %CompanyUser{}}

      iex> create_company_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company_user(attrs \\ %{}) do
    %CompanyUser{}
    |> CompanyUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company_user.

  ## Examples

      iex> update_company_user(company_user, %{field: new_value})
      {:ok, %CompanyUser{}}

      iex> update_company_user(company_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company_user(%CompanyUser{} = company_user, attrs) do
    company_user
    |> CompanyUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company_user.

  ## Examples

      iex> delete_company_user(company_user)
      {:ok, %CompanyUser{}}

      iex> delete_company_user(company_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company_user(%CompanyUser{} = company_user) do
    Repo.delete(company_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company_user changes.

  ## Examples

      iex> change_company_user(company_user)
      %Ecto.Changeset{data: %CompanyUser{}}

  """
  def change_company_user(%CompanyUser{} = company_user, attrs \\ %{}) do
    CompanyUser.changeset(company_user, attrs)
  end
end
