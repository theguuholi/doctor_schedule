defmodule DoctorSchedule.AppointmentFixture do
  alias DoctorSchedule.Appointments.Repositories.AppointmentsRepository
  alias DoctorSchedule.UserFixture

  def valid_appointment(user_id \\ nil) do
    %{
      date: ~N[2010-04-17 14:00:00],
      provider_id: UserFixture.create_provider().id,
      user_id: user_id || UserFixture.create_user().id
    }
  end

  def update_appointment do
    %{
      date: ~N[2011-05-18 15:01:01],
      provider_id: UserFixture.create_provider().id,
      user_id: UserFixture.create_user().id
    }
  end

  def invalid_appointment, do: %{date: nil}

  def appointment_fixture(user_id \\ nil) do
    {:ok, appointment} =
      valid_appointment(user_id)
      |> AppointmentsRepository.create_appointment()

    appointment
  end
end
