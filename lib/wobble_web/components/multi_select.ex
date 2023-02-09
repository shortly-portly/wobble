defmodule WobbleWeb.SelectComponent do
  use WobbleWeb, :live_component

  alias Phoenix.LiveView.JS
  alias Phoenix.HTML.Form

  def render(assigns) do
    ~H"""
    <div>
      <div class="w-2/3 flex justify-end items-center relative" phx-click={toggle(assigns.id)}>
        <input
          type="text"
          phx-keyup="keypress"
          phx-target={@myself}
          value={@selected_label}
          id={"#{@id}-selected-option-container"}
          class="border border-gray-400 rounded-lg p-4 w-full"
        />
        <%= arrows(assigns) %>
      </div>
      <div
        class="hidden w-96 p-4 absolute z-10 shadow-2xl rounded-lg bg-white"
        id={"#{@id}-options-container"}
      >
        <%= for {id, label} <- @options do %>
          <p
            class="text-red-500 hover:cursor-pointer hover:text-blue-500"
            phx-click={
              JS.push("selected", value: %{id: id, label: label}, target: @myself)
              |> toggle(assigns.id)
            }
            phx-click-away={toggle(assigns.id)}
          >
            <%= label %>
          </p>
        <% end %>
      </div>
      <div>
        <%= Form.hidden_input(@form, @field, value: @selected_id) %>
      </div>
    </div>
    """
  end

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

    {:ok, socket}
  end

  def handle_event("selected", %{"id" => id, "label" => label}, socket) do
    socket =
      socket
      |> assign(:selected_id, id)
      |> assign(:selected_label, label)

    {:noreply, socket}
  end

  def handle_event("keypress", _data, socket) do
    {:noreply, socket}
  end

  defp arrows(assigns) do
    ~H"""
    <div class="absolute mr-2 w-10">
      <svg id={"#{@id}-down-icon"} viewBox="0 0 20 20" fill="currentColor">
        <path
          fill-rule="evenodd"
          d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
          clip-rule="evenodd"
        />
      </svg>
      <svg
        id={"#{@id}-up-icon"}
        xmlns="http://www.w3.org/2000/svg"
        class="hidden"
        viewBox="0 0 20 20"
        fill="currentColor"
      >
        <path
          fill-rule="evenodd"
          d="M14.707 12.707a1 1 0 01-1.414 0L10 9.414l-3.293 3.293a1 1 0 01-1.414-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 010 1.414z"
          clip-rule="evenodd"
        />
      </svg>
    </div>
    """
  end

  defp toggle(js \\ %JS{}, id) do
    js
    |> JS.toggle(to: "##{id}-up-icon")
    |> JS.toggle(to: "##{id}-down-icon")
    |> JS.toggle(to: "##{id}-options-container")
  end
end
