defmodule DoctorSchedule.Appointments.Repositories.ProviderRepositoryTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.AppointmentFixture
  alias DoctorSchedule.Appointments.Repositories.ProviderRepository
  alias DoctorSchedule.Repo

  describe "Tests Provider in Appointments" do
    test "all_day_fom_provider/2 returns all appointments from provider in a month" do
      appointment = AppointmentFixture.appointment_fixture()
      appointment = appointment |> Repo.preload(:provider)
      date = NaiveDateTime.to_date(appointment.date)

      assert ProviderRepository.all_day_fom_provider(appointment.provider.id, date)
             |> Enum.count() == 1
    end

    test "all_month_from_provider/3 returns all appointments from provider in a month" do
      appointment = AppointmentFixture.appointment_fixture()
      appointment = appointment |> Repo.preload(:provider)
      year = appointment.date.year
      month = appointment.date.month

      assert ProviderRepository.all_month_from_provider(appointment.provider.id, year, month)
             |> Enum.count() == 1
    end
  end
end
