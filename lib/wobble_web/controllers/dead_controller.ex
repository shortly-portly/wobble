defmodule WobbleWeb.DeadController do
  use WobbleWeb, :controller

  alias Wobble.Swamps
  alias Wobble.Swamps.Dead

  def index(conn, _params) do
    dead = Swamps.list_dead()
    render(conn, :index, dead: dead)
  end

  def new(conn, _params) do
    changeset = Swamps.change_dead(%Dead{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"dead" => dead_params}) do
    case Swamps.create_dead(dead_params) do
      {:ok, dead} ->
        conn
        |> put_flash(:info, "Dead created successfully.")
        |> redirect(to: ~p"/dead/#{dead}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    dead = Swamps.get_dead!(id)
    render(conn, :show, dead: dead)
  end

  def edit(conn, %{"id" => id}) do
    dead = Swamps.get_dead!(id)
    changeset = Swamps.change_dead(dead)
    render(conn, :edit, dead: dead, changeset: changeset)
  end

  def update(conn, %{"id" => id, "dead" => dead_params}) do
    dead = Swamps.get_dead!(id)

    case Swamps.update_dead(dead, dead_params) do
      {:ok, dead} ->
        conn
        |> put_flash(:info, "Dead updated successfully.")
        |> redirect(to: ~p"/dead/#{dead}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, dead: dead, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    dead = Swamps.get_dead!(id)
    {:ok, _dead} = Swamps.delete_dead(dead)

    conn
    |> put_flash(:info, "Dead deleted successfully.")
    |> redirect(to: ~p"/dead")
  end
end
