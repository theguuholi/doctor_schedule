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

config :doctor_schedule, DoctorScheduleWeb.Auth.Guardian,
  issuer: "doctor_schedule",
  secret_key: System.get_env("GUARDIAN_SECRET") || "123123"

config :doctor_schedule, DoctorSchedule.Shared.MailProvider.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: System.get_env("SMTP_HOST"),
  hostname: System.get_env("SMTP_HOST"),
  port: System.get_env("SMTP_PORT"),
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: false,
  retries: 1,
  no_mx_lookup: false,
  auth: :cram_md5

config :doctor_schedule, :mongo_db,
  url: System.get_env("MONGO_URL") || "mongodb://localhost:27017/doctor_schedule",
  pool_size: (System.get_env("MONGO_POOL_SIZE") || "10") |> String.to_integer()

config :doctor_schedule, :redis_config,
  url: System.get_env("REDIS_URL") || "redis://localhost:6379"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
