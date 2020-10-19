defmodule DoctorSchedule.Repo do
  use Ecto.Repo,
    otp_app: :doctor_schedule,
    adapter: Ecto.Adapters.Postgres
end
