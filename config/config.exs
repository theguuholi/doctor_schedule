# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :doctor_schedule,
  ecto_repos: [DoctorSchedule.Repo]

# Configures the endpoint
config :doctor_schedule, DoctorScheduleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+XaX6rr66nqffuLDTxzXMDiyE9fGyMLjCyfr3gxE/lTbfxnfF1aPJZgITY8FE59N",
  render_errors: [view: DoctorScheduleWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DoctorSchedule.PubSub,
  live_view: [signing_salt: "B5g2ue35"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
