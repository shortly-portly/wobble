defmodule Wobble.Swamps do
  @moduledoc """
  The Swamps context.
  """

  import Ecto.Query, warn: false
  alias Wobble.Repo

  alias Wobble.Swamps.Dead

  @doc """
  Returns the list of dead.

  ## Examples

      iex> list_dead()
      [%Dead{}, ...]

  """
  def list_dead do
    Repo.all(Dead)
  end

  @doc """
  Gets a single dead.

  Raises `Ecto.NoResultsError` if the Dead does not exist.

  ## Examples

      iex> get_dead!(123)
      %Dead{}

      iex> get_dead!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dead!(id), do: Repo.get!(Dead, id)

  @doc """
  Creates a dead.

  ## Examples

      iex> create_dead(%{field: value})
      {:ok, %Dead{}}

      iex> create_dead(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dead(attrs \\ %{}) do
    %Dead{}
    |> Dead.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dead.

  ## Examples

      iex> update_dead(dead, %{field: new_value})
      {:ok, %Dead{}}

      iex> update_dead(dead, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dead(%Dead{} = dead, attrs) do
    dead
    |> Dead.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a dead.

  ## Examples

      iex> delete_dead(dead)
      {:ok, %Dead{}}

      iex> delete_dead(dead)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dead(%Dead{} = dead) do
    Repo.delete(dead)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dead changes.

  ## Examples

      iex> change_dead(dead)
      %Ecto.Changeset{data: %Dead{}}

  """
  def change_dead(%Dead{} = dead, attrs \\ %{}) do
    Dead.changeset(dead, attrs)
  end
end
