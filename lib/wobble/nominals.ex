defmodule Wobble.Nominals do
  @moduledoc """
  The Nominals context.
  """

  import Ecto.Query, warn: false
  alias Wobble.Repo

  alias Wobble.Nominals.Nominal

  @doc """
  Returns the list of nominals.

  ## Examples

      iex> list_nominals()
      [%Nominal{}, ...]

  """
  def list_nominals do
    Repo.all(Nominal)
  end

  @doc """
  Gets a single nominal.

  Raises `Ecto.NoResultsError` if the Nominal does not exist.

  ## Examples

      iex> get_nominal!(123)
      %Nominal{}

      iex> get_nominal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_nominal!(id), do: Repo.get!(Nominal, id)

  @doc """
  Creates a nominal.

  ## Examples

      iex> create_nominal(%{field: value})
      {:ok, %Nominal{}}

      iex> create_nominal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_nominal(attrs \\ %{}) do
    %Nominal{}
    |> Nominal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a nominal.

  ## Examples

      iex> update_nominal(nominal, %{field: new_value})
      {:ok, %Nominal{}}

      iex> update_nominal(nominal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_nominal(%Nominal{} = nominal, attrs) do
    nominal
    |> Nominal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a nominal.

  ## Examples

      iex> delete_nominal(nominal)
      {:ok, %Nominal{}}

      iex> delete_nominal(nominal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_nominal(%Nominal{} = nominal) do
    Repo.delete(nominal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking nominal changes.

  ## Examples

      iex> change_nominal(nominal)
      %Ecto.Changeset{data: %Nominal{}}

  """
  def change_nominal(%Nominal{} = nominal, attrs \\ %{}) do
    Nominal.changeset(nominal, attrs)
  end
end
