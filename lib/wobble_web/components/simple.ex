defmodule WobbleWeb.RepCatSelect do
  use WobbleWeb, :live_component

  alias Phoenix.HTML.Form
  alias Wobble.ReportCategories

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id} phx-hook="MySelect" class="mt-6 w-1/2">
      <.input field={@field} type="hidden" value={@selected_id} />
      <div phx-feedback-for={@selected_text}>
        <.label for={@id}><%= @label %></.label>
        <input
          type="text"
          value={@selected_text}
          class={[
            input_border(@errors),
            "mt-2 block w-full rounded-lg border-zinc-300 py-[7px] px-[11px]",
            "text-zinc-900 focus:outline-none focus:ring-4 sm:text-sm sm:leading-6",
            "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400 phx-no-feedback:focus:ring-zinc-800/5"
          ]}
          phx-keyup="search"
          phx-target={@myself}
        />
        <div><%= @selected_category %> <%= @selected_type %></div>
        <.error :for={msg <- @errors}><%= msg %></.error>
      </div>
      <div
        class="hidden w-1/2 p-4 absolute z-10 shadow-2xl rounded-lg bg-white overflow-y-auto h-32"
        id={"#{@id}-options-container"}
      >
        <%= for option <- @filtered_options do %>
          <p>
            <div
              class={"#{@id}-option hover:cursor-pointer hover:text-blue-500 flex flex-row"}
              data-id={option.id}
            >
              <div class="basis-1/3">
                <%= option.code %>
              </div>
              <div class="basis-2/3">
                <%= option.name %>
              </div>
            </div>
          </p>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {f, field} = assigns.field
    options = ReportCategories.select_report_categories(assigns.current_company_id)
    hidden_field = Form.input_value(f, field)

    selected_option = select_option(hidden_field, options)

    socket =
      socket
      |> assign(assigns)
      |> assign(:options, options)
      |> assign(:filtered_options, options)
      |> assign(:selected_id, selected_option.id)
      |> assign(:selected_text, selected_option.name)
      |> assign(:selected_category, selected_option.category)
      |> assign(:selected_type, selected_option.type)
      |> assign_new(:errors, fn -> translate_errors(f.errors || [], field) end)

    {:ok, socket}
  end

  @impl true
  def handle_event("selected", %{"component_id" => component_id, "id" => id}, socket) do
    selected_option = select_option(id, socket.assigns.options)

    {:noreply,
     socket
     |> assign(:selected_id, selected_option.id)
     |> assign(:selected_text, selected_option.name)
     |> assign(:selected_category, selected_option.category)
     |> assign(:selected_type, selected_option.type)
     |> push_event("select", %{component_id: component_id, selected_option: selected_option})}
  end

  def handle_event("blur", _params, socket) do
    {:noreply,
     socket
     |> push_event("select", %{id: socket.assigns.selected_id, name: socket.assigns.selected_text})}
  end

  def handle_event("search", %{"value" => value}, socket) do
    {:noreply, socket |> assign(:filtered_options, search_options(value, socket.assigns.options))}
  end

  defp search_options(value, options) do
    # Note: We convert the integer code value to string. This is very inefficient and we should really store it as a string to prevent this.
    Enum.filter(options, fn option ->
      String.contains?(option.name, value) ||
        String.contains?(Integer.to_string(option.code), value)
    end)
  end

  defp select_option(id, options) when is_bitstring(id) do
    select_option(String.to_integer(id), options)
  end

  defp select_option(id, options) when is_integer(id) do
    Enum.find(options, fn option -> option.id == id end)
  end

  defp select_option(id, options) when is_nil(id) do
    Enum.at(options, 0)
  end

  defp input_border([] = _errors),
    do: "border-zinc-300 focus:border-zinc-400 focus:ring-zinc-800/5"

  defp input_border([_ | _] = _errors),
    do: "border-rose-400 focus:border-rose-400 focus:ring-rose-400/10"
end
