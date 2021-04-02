defmodule DoctorSchedule.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias DoctorSchedule.Shared.Cache.Ets.CacheEts

  def start(_type, _args) do
    url = Application.get_env(:doctor_schedule, :mongo_db)[:url]
    pool_size = Application.get_env(:doctor_schedule, :mongo_db)[:pool_size]

    redis_url = Application.get_env(:doctor_schedule, :redis_config)[:url]

    children = [
      # Start the Ecto repository
      DoctorSchedule.Repo,
      # Start the Telemetry supervisor
      DoctorScheduleWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DoctorSchedule.PubSub},
      # Start the Endpoint (http/https)
      DoctorScheduleWeb.Endpoint,
      # {Mongo, [name: :mongo, url: url, pool_size: pool_size]},
      {Redix, {redis_url, [name: :redis_server]}},
      build_cache(:providers)
      # Start a worker by calling: DoctorSchedule.Worker.start_link(arg)
      # {DoctorSchedule.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DoctorSchedule.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp build_cache(name), do: %{id: name, start: {CacheEts, :start_link, [name]}}

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DoctorScheduleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
