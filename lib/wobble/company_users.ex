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
  def list_company_users() do
    Repo.all(CompanyUser)
  end
  
  @doc """
  Returns a list of users associated with this company.

  ## Examples

      iex> list_users_for_company(123)
      [%CompanyUser{}, ...]
  """
  def list_users_for_company(company_id) do
    from(
      cu in CompanyUser,
      where: cu.company_id== ^company_id,
      preload: [:user]
    )
    |> Repo.all() 
  end

  @doc """
  Returns the list of companies associated with this user.

  ## Examples

      iex> list_company_users(123)
      [%CompanyUser{}, ...]

  """
  def list_companies_for_user(user_id) do
    from(
      cu in CompanyUser,
      where: cu.user_id == ^user_id,
      preload: [:company]
    )
    |> Repo.all()
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
  Get a single company_user for the company/user id combination. 

  This function is useful for confirming that a specific company/user id combination exists. 
  For ecample when a user selects a company.
      iex> get_company_user_for_company!(123, 355)
      %CompanyUser{}

      iex> get_company_user_for_company!(123, 12)
      ** (Ecto.NoResultsError)
    
  """
  def get_company_user_for_company!(user_id, company_id) do
    from(
      cu in CompanyUser,
      where: cu.user_id == ^user_id,
      where: cu.company_id == ^company_id,
      preload: [:company]
    )
    |> Repo.one!()
  end

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
