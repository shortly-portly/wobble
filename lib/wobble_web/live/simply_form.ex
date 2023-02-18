defmodule WobbleWeb.SimpleForm do
  use WobbleWeb, :live_view

  import LiveSelect

  defmodule Form do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field(:name, :string)
      field(:age, :integer)
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
        <.live_select form={f} field={:city_search} options={@options}/>
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
    options = [{'Tea', 1}, {'Cheese', 2}, {'Lager', 3}]

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

  @impl true
  def handle_event("live_select_change", %{"text" => text, "id" => live_select_id}, socket) do
    options = [{'Tea', 1}, {'Cheese', 2}, {'Lager', 3}, {'Table', 4}]

    send_update(LiveSelect.Component, id: live_select_id, options: options)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "change",
        %{"my_form" => %{"city_search_text_input" => city_name, "city_search" => city_coords}},
        socket
      ) do
    IO.puts("You selected city #{city_name} located at: #{city_coords}")

    {:noreply, socket}
  end
end
