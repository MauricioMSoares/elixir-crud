defmodule ElixirCrud.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirCrudWeb.Telemetry,
      ElixirCrud.Repo,
      {DNSCluster, query: Application.get_env(:elixir_crud, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirCrud.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElixirCrud.Finch},
      # Start a worker by calling: ElixirCrud.Worker.start_link(arg)
      # {ElixirCrud.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirCrudWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirCrud.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirCrudWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
