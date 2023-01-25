defmodule WobbleWeb.UserRegistrationLive do
  @moduledoc """
  A modified version of the User Registration Live created my phx.gen.auth.

  We include a checkbox to indicate whether the newly created user should be added
  to the current company (the one associated with the currently logged in user). 

  As this is a simple checkbox with no validation we haven't created an embedded Schema
  for the form as you would do if the data was more complex or required validation. We 
  simply added an attribute to the layout and handle it manually.
  """
  use WobbleWeb, :auth_live_view

  alias Wobble.Accounts
  alias Wobble.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Create User with Embedded Schema
      </.header>

      <.simple_form
        :let={f}
        id="registration_form"
        for={@changeset}
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
        as={:user}
      >
        <.error :if={@changeset.action == :insert}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={{f, :email}} type="email" label="Email" required />
        <.input field={{f, :password}} type="password" label="Password" required />

        <.input
          field={{f, :add_to_company}}
          type="checkbox"
          label="Add to Company"
          value={@add_to_company}
        />

        <:actions>
          <.button phx-disable-with="Creating user...">Create User</.button>
        </:actions>
      </.simple_form>
      <.back navigate={~p"/users"}>Back to users</.back>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_organisation_registration(%User{})

    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(add_to_company: true)
      |> assign(trigger_submit: false)

    {:ok, socket, temporary_assigns: [changeset: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user_params =
      Map.put(user_params, "organisation_id", socket.assigns.current_user.organisation_id)

    case Accounts.register_user(user_params, socket.assigns.current_company_id) do
      {:ok, %{user: user}} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, assign(socket, trigger_submit: true, changeset: changeset)}

      {:error, :user, %Ecto.Changeset{} = changeset, _rest} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    add_to_company = user_params["add_to_company"] 

    {:noreply,
     socket
     |> assign(changeset: Map.put(changeset, :action, :validate))
     |> assign(add_to_company: add_to_company)}
  end
end
