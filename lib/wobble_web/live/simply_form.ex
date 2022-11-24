defmodule WobbleWeb.SimpleForm do
  use WobbleWeb, :live_view

  defmodule Form do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field :name, :string
      field :age, :integer
    end

    def changeset(form, params) do
      form
      |> cast(params, [:name, :age])
    end
  end

  def render(assigns) do
    ~H"""
    <.simple_form
      :let={f}
      for={@changeset}
      id="simple-form"
      phx-change="validate"
      phx-submit="submit"
    >
      <.input field={{f, :name}} type="text" label="name" />
      <.input field={{f, :age}} type="number" label="age" />
      <.live_component
        module={WobbleWeb.SelectComponent}
        id="my-select"
        field={{f, :foobar}}
        options={@options}
      />
      <:actions>
        <.button phx-disable-with="Saving...">Save Simple Form</.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    form = %Form{}
    changeset = Form.changeset(%Form{}, %{})
    options = [{1, 'Tea'}, {2, 'Cheese'}, {3, 'Lager'}]
    socket =
      socket
      |> assign(form: form)
      |> assign(changeset: changeset)
      |> assign(options: options)

    {:ok, socket}
  end

  def handle_event("validate", %{"form" => params}, socket) do

    changeset =
      socket.assigns.form
      |> Form.changeset(params)
      |> struct!(action: :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end
end
