defmodule WobbleWeb.RepCatSelect do
  use WobbleWeb, :live_component

  alias Phoenix.LiveView.JS
  alias Phoenix.HTML.Form

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id} phx-hook="ReportCategory">
      <div class="w-2/3 flex justify-end items-center relative">
        <input
          type="text"
          value={@selected_label}
          phx-target={@myself}
          id={"#{@id}-selected-option-container"}
          class="border border-gray-400 rounded-lg p-4 w-full"
        />
      </div>
      <div
        class="hidden w-96 p-4 absolute z-10 shadow-2xl rounded-lg bg-white"
        id={"#{@id}-options-container"}
      >
        <%= for {option, idx} <- Enum.with_index(@options) do %>
          <p
            class={[
              "hover:cursor-pointer hover:text-blue-500",
              if(idx == @active_option, do: "text-red-500")
            ]}
            phx-click={
              JS.push("selected", value: %{id: option.id, name: option.name}, target: @myself)
            }
            phx-click-away={JS.push('clicked-away', value: %{}, target: @myself)}
          >
            <%= option.name %> - <%= option.category %>
          </p>
        <% end %>
      </div>
      <div>
        <%= Form.hidden_input(@form, @field, value: @selected_id) %>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{id: id, field: field, options: options}, socket) do
    {form, field} = field

    socket =
      socket
      |> assign(:id, id)
      |> assign(:form, form)
      |> assign(:field, field)
      |> assign(:selected_id, nil)
      |> assign(:selected_label, "Please select an option")
      |> assign(:options, options)
      |> assign(:active_option, -1)

    {:ok, socket}
  end

  @impl true
  def handle_event("selected", %{"id" => id}, socket) do

    selected_option = select_option(String.to_integer(id), socket.assigns.options)

    {:noreply,
     socket
     |> assign(:selected_id, selected_option.id)
     |> assign(:selected_text, selected_option.name)
     |> push_event("select", selected_option)}
  end

  def handle_event("keypress", _data, socket) do
    {:noreply, socket}
  end

  defp select_option(id, options) do
    Enum.find(options, fn option -> option.id == id end)
  end
end
