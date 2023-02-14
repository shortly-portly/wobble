defmodule Wobble.ReportCategories do
  @moduledoc """
  The ReportCategories context.
  """

  import Ecto.Query, warn: false
  alias Wobble.Repo

  alias Wobble.ReportCategories.ReportCategory

  @doc """
  Returns the list of Report Categories associated with the given company id.

  ## Examples

      iex> list_report_categories(123)
      [%Company{}, ...]

  """
  def list_report_categories(company_id) do
    from(
      rc in ReportCategory,
      where: rc.company_id == ^company_id
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of report_categories.

  ## Examples

      iex> list_report_categories()
      [%ReportCategory{}, ...]

  """
  def list_report_categories do
    Repo.all(ReportCategory)
  end

  @doc """
  Returns the list, suitable for use in a select component, of Report Categories associated with the given company id.

  ## Examples

      iex> select_report_categories(123)
      [%Company{}, ...]

  """
  def select_report_categories(company_id) do
    from(
      rc in ReportCategory,
      where: rc.company_id == ^company_id,
      select: {rc.name, rc.id}
    )
    |> Repo.all()
  end

  @doc """
  Gets a single report_category.

  Raises `Ecto.NoResultsError` if the Report category does not exist.

  ## Examples

      iex> get_report_category!(123)
      %ReportCategory{}

      iex> get_report_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_report_category!(id), do: Repo.get!(ReportCategory, id)

  @doc """
  Creates a report_category.

  ## Examples

      iex> create_report_category(%{field: value})
      {:ok, %ReportCategory{}}

      iex> create_report_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_report_category(attrs \\ %{}) do
    %ReportCategory{}
    |> ReportCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a report_category.

  ## Examples

      iex> update_report_category(report_category, %{field: new_value})
      {:ok, %ReportCategory{}}

      iex> update_report_category(report_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_report_category(%ReportCategory{} = report_category, attrs) do
    report_category
    |> ReportCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a report_category.

  ## Examples

      iex> delete_report_category(report_category)
      {:ok, %ReportCategory{}}

      iex> delete_report_category(report_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_report_category(%ReportCategory{} = report_category) do
    Repo.delete(report_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking report_category changes.

  ## Examples

      iex> change_report_category(report_category)
      %Ecto.Changeset{data: %ReportCategory{}}

  """
  def change_report_category(%ReportCategory{} = report_category, attrs \\ %{}) do
    ReportCategory.changeset(report_category, attrs)
  end
end
