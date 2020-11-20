defmodule DoctorSchedule.AppointmentFixture do
  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.Appointments
  alias DoctorSchedule.UserFixture

  def valid_appointment do
    %{date: ~N[2010-04-17 14:00:00], provider_id: create_provider().id, user_id: create_user().id}
  end

  def update_appointment do
    %{date: ~N[2011-05-18 15:01:01], provider_id: create_provider().id, user_id: create_user().id}
  end

  def invalid_appointment, do: %{date: nil}

  defp create_user do
    {:ok, user} =
      UserFixture.valid_user()
      |> AccountRepository.create_user()

    user
  end

  defp create_provider do
    {:ok, provider} =
      UserFixture.provider_user()
      |> AccountRepository.create_user()

    provider
  end

  def appointment_fixture do
    {:ok, appointment} =
      valid_appointment()
      |> Appointments.create_appointment()

    appointment
  end
end
