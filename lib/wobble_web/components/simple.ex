defmodule WobbleWeb.Simple do
  use WobbleWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id} phx-hook="MySelect">
      <%= @name %>
      <div class="w-2/3 flex justify-end items-center relative">
        <input
          type="text"
          value={@name}
          class="border border-gray-400 rounded-lg p-4 w-full"
          phx-keyup="search"
          phx-target={@myself}
        />
      </div>
      <div
        class="hidden w-96 p-4 absolute z-10 shadow-2xl rounded-lg bg-white"
        id={"#{@id}-options-container"}
      >
        <%= for option <- @options do %>
          <p>
            <div class={"#{@id}-option hover:cursor-pointer hover:text-blue-500"} data-id={option.id}>
              <%= option.name %> - <%= option.category %>
            </div>
          </p>
        <% end %>
      </div>
    </div>
    """
  end

  @options [
    %{id: 1, name: "Dave 1", category: "category 1"},
    %{id: 2, name: "Blanche 2", category: "category 2"},
    %{id: 3, name: "Kim 3", category: "category 3"},
    %{id: 4, name: "Chase 4", category: "category 4"},
    %{id: 5, name: "Robert 5", category: "category 5"},
    %{id: 6, name: "Tom 6", category: "category 6"}
  ]

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:options, @options)
      |> assign(:name, "")

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

  def handle_event("search", %{"value" => value}, socket) do
    {:noreply, socket |> assign(:options, search_options(value, socket.assigns.options))}
  end

  defp search_options(text, _options) do
    Enum.filter(@options, fn option -> String.contains?(option.name, text) end) |> dbg()
  end

  defp select_option(id, options) do
    Enum.find(options, fn option -> option.id == id end)
  end
end
