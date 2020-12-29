use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :doctor_schedule, DoctorSchedule.Repo,
  username: "postgres",
  password: "postgres",
  database: "doctor_schedule_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :doctor_schedule, DoctorScheduleWeb.Endpoint,
  http: [port: 4002],
  server: false

config :doctor_schedule, DoctorSchedule.Shared.MailProvider.Mailer, adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn

config :doctor_schedule, :mongo_db,
  url: "mongodb://localhost:27017/doctor_schedule",
  pool_size: 10

config :doctor_schedule, :redis_config, url: "redis://localhost:6379"
