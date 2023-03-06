defmodule Wobble.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wobble.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        date: ~D[2023-03-04],
        name: "some name"
      })
      |> Wobble.Transactions.create_transaction()

    transaction
  end
end
