defmodule Wobble.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WobbleWeb.Telemetry,
      # Start the Ecto repository
      Wobble.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Wobble.PubSub},
      # Start Finch
      {Finch, name: Wobble.Finch},
      # Start the Endpoint (http/https)
      WobbleWeb.Endpoint
      # Start a worker by calling: Wobble.Worker.start_link(arg)
      # {Wobble.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wobble.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WobbleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
