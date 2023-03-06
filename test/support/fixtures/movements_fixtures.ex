defmodule Wobble.MovementsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wobble.Movements` context.
  """

  @doc """
  Generate a movement.
  """
  def movement_fixture(attrs \\ %{}) do
    {:ok, movement} =
      attrs
      |> Enum.into(%{
        amount: 42,
        description: "some description"
      })
      |> Wobble.Movements.create_movement()

    movement
  end
end
