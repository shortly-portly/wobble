defmodule WobbleWeb.SimpleForm do
  use WobbleWeb, :live_view

  alias Wobble.ReportCategories

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

  @impl true
  def render(assigns) do
    ~H"""
    <.simple_form :let={f} for={@changeset} id="simple-form" phx-change="validate" phx-submit="submit">
      <div class="flex flex-col">
        <.input field={{f, :name}} type="text" label="name" />
        <.input field={{f, :address_line_1}} type="text" label="Address" />

        <.live_component
          module={WobbleWeb.Simple}
          id="woobar"
          field={{f, :dog}}
          label="Report Category"
          current_company_id={@current_company_id}
        />
        <.input field={{f, :address_line_2}} type="text" />
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

  @impl true
  def mount(_params, _session, socket) do
    form = %Form{}
    changeset = Form.changeset(%Form{}, %{})

    report_categories =
      ReportCategories.select_report_categories(socket.assigns.current_company_id)

    _options = [{'Tea', 1}, {'Cheese', 2}, {'Lager', 3}]

    socket =
      socket
      |> assign(form: form)
      |> assign(changeset: changeset)
      |> assign(options: report_categories)

    {:ok, socket}
  end

  def handle_event("validate", _params, socket) do
    #    changeset =
    #  socket.assigns.form
    #  |> Form.changeset(params)
    #  |> struct!(action: :validate)

    # {:noreply, assign(socket, changeset: changeset)}

    {:noreply, socket}
  end

  @impl true
  def handle_event("live_select_change", %{"text" => _text, "id" => live_select_id}, socket) do
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
