defmodule PosterApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PosterApp.Repo,
      # Start the Telemetry supervisor
      PosterAppWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PosterApp.PubSub},
      # Start the Endpoint (http/https)
      PosterAppWeb.Endpoint
      # Start a worker by calling: PosterApp.Worker.start_link(arg)
      # {PosterApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PosterApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PosterAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
