defmodule Wobble.OrganisationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wobble.Organisations` context.
  """

  @doc """
  Generate a organisation.
  """
  def organisation_fixture(attrs \\ %{}) do
    {:ok, organisation} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Wobble.Organisations.create_organisation()

    organisation
  end
end
