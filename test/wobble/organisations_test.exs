defmodule Wobble.OrganisationsTest do
  use Wobble.DataCase

  alias Wobble.Organisations

  describe "organisation" do
    alias Wobble.Organisations.Organisation

    import Wobble.OrganisationsFixtures

    @invalid_attrs %{name: nil}

    test "list_organisation/0 returns all organisation" do
      organisation = organisation_fixture()
      assert Organisations.list_organisation() == [organisation]
    end

    test "get_organisation!/1 returns the organisation with given id" do
      organisation = organisation_fixture()
      assert Organisations.get_organisation!(organisation.id) == organisation
    end

    test "create_organisation/1 with valid data creates a organisation" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Organisation{} = organisation} = Organisations.create_organisation(valid_attrs)
      assert organisation.name == "some name"
    end

    test "create_organisation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organisations.create_organisation(@invalid_attrs)
    end

    test "update_organisation/2 with valid data updates the organisation" do
      organisation = organisation_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Organisation{} = organisation} = Organisations.update_organisation(organisation, update_attrs)
      assert organisation.name == "some updated name"
    end

    test "update_organisation/2 with invalid data returns error changeset" do
      organisation = organisation_fixture()
      assert {:error, %Ecto.Changeset{}} = Organisations.update_organisation(organisation, @invalid_attrs)
      assert organisation == Organisations.get_organisation!(organisation.id)
    end

    test "delete_organisation/1 deletes the organisation" do
      organisation = organisation_fixture()
      assert {:ok, %Organisation{}} = Organisations.delete_organisation(organisation)
      assert_raise Ecto.NoResultsError, fn -> Organisations.get_organisation!(organisation.id) end
    end

    test "change_organisation/1 returns a organisation changeset" do
      organisation = organisation_fixture()
      assert %Ecto.Changeset{} = Organisations.change_organisation(organisation)
    end
  end
end
