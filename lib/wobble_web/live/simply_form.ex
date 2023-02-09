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
    <.simple_form :let={f} for={@changeset} id="simple-form" phx-change="validate" phx-submit="submit">
      <div class="flex flex-col">
        <.input field={{f, :name}} type="text" label="name" />
        <.input field={{f, :age}} type="number" label="age" />
        <.live_component module={WobbleWeb.ReportCategoryComponent} id="foo" field={{f, :wobble}} />
        <.live_component
          module={WobbleWeb.SelectComponent}
          id="my-select"
          field={{f, :foobar}}
          options={@options}
        />
      </div>
      <:actions>
        <.button phx-disable-with="Saving...">Save Simple Form</.button>
      </:actions>
    </.simple_form>

    <.link patch={~p"/welcome"}>Welcome</.link>

    <div class="flex flex-col">
      <div class="mt-4">
        <div>Label 1</div>
        <div><input type="text" /></div>
      </div>

      <div class="mt-4">
        <div>Label 2</div>
        <div><input type="text" /></div>
      </div>
    </div>
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
    IO.puts("validte called")

    changeset =
      socket.assigns.form
      |> Form.changeset(params)
      |> struct!(action: :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end
end
