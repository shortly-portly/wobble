defmodule Wobble.NominalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wobble.Nominals` context.
  """

  @doc """
  Generate a nominal.
  """
  def nominal_fixture(attrs \\ %{}) do
    {:ok, nominal} =
      attrs
      |> Enum.into(%{
        balance: 42,
        code: "some code",
        name: "some name"
      })
      |> Wobble.Nominals.create_nominal()

    nominal
  end
end
