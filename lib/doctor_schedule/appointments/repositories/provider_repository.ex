defmodule DoctorSchedule.Appointments.Repositories.ProviderRepository do
  import Ecto.Query, warn: false
  alias DoctorSchedule.Appointments.Entities.Appointment
  alias DoctorSchedule.Repo

  def all_day_fom_provider(provider_id, date) do
    {:ok, start_date} = NaiveDateTime.new(date, ~T[00:00:00.000])
    {:ok, end_date} = NaiveDateTime.new(date, ~T[23:59:59.999])

    query =
      from a in Appointment,
        where: a.provider_id == ^provider_id and (a.date >= ^start_date and a.date <= ^end_date),
        order_by: a.date

    Repo.all(query)
    |> Repo.preload(:user)
  end

  def all_month_from_provider(provider_id, year, month) do
    {:ok, start_date} = Date.new(year, month, 01)
    days = Date.days_in_month(start_date)
    {:ok, end_date} = Date.new(year, month, days)
    {:ok, start_date} = NaiveDateTime.new(start_date, ~T[00:00:00.000])
    {:ok, end_date} = NaiveDateTime.new(end_date, ~T[23:59:59.999])

    query =
      from a in Appointment,
        where:
          a.provider_id == ^provider_id and
            (a.date >= ^start_date and a.date <= ^end_date)

    Repo.all(query)
  end
end
