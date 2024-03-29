defmodule Wobble.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wobble.Accounts` context.
  """

  import Wobble.OrganisationsFixtures

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def valid_organisation_id do 
    organisation = organisation_fixture()  
    organisation.id
  end

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      organisation_id: valid_organisation_id() 
    })
  end

  def valid_organisation_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      organisation: %{
        name: "Big Co"}
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, %{user: user}} =
      attrs
      |> valid_user_attributes()
      |> Wobble.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
