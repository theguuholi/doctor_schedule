defmodule DoctorSchedule.AppointmentsTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.AppointmentFixture
  alias DoctorSchedule.Appointments.Repositories.AppointmentsRepository

  describe "appointments" do
    alias DoctorSchedule.Appointments.Entities.Appointment

    test "list_appointments/0 returns all appointments" do
      AppointmentFixture.appointment_fixture()
      assert AppointmentsRepository.list_appointments() |> Enum.count() == 1
    end

    test "get_appointment!/1 returns the appointment with given id" do
      appointment = AppointmentFixture.appointment_fixture()
      assert AppointmentsRepository.get_appointment!(appointment.id).id == appointment.id
    end

    test "create_appointment/1 with valid data creates a appointment" do
      assert {:ok, %Appointment{} = appointment} =
               AppointmentsRepository.create_appointment(AppointmentFixture.valid_appointment())

      assert appointment.date == ~N[2010-04-17 14:00:00]
    end

    test "create_appointment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               AppointmentsRepository.create_appointment(AppointmentFixture.invalid_appointment())
    end

    test "update_appointment/2 with valid data updates the appointment" do
      appointment = AppointmentFixture.appointment_fixture()

      assert {:ok, %Appointment{} = appointment} =
               AppointmentsRepository.update_appointment(
                 appointment,
                 %{date: ~N[2011-05-18 15:01:01]}
               )

      assert appointment.date == ~N[2011-05-18 15:01:01]
    end

    test "update_appointment/2 with invalid data returns error changeset" do
      appointment = AppointmentFixture.appointment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               AppointmentsRepository.update_appointment(
                 appointment,
                 AppointmentFixture.invalid_appointment()
               )

      assert appointment.id == AppointmentsRepository.get_appointment!(appointment.id).id
    end

    test "delete_appointment/1 deletes the appointment" do
      appointment = AppointmentFixture.appointment_fixture()
      assert {:ok, %Appointment{}} = AppointmentsRepository.delete_appointment(appointment)

      assert_raise Ecto.NoResultsError, fn ->
        AppointmentsRepository.get_appointment!(appointment.id)
      end
    end

    test "change_appointment/1 returns a appointment changeset" do
      appointment = AppointmentFixture.appointment_fixture()
      assert %Ecto.Changeset{} = AppointmentsRepository.change_appointment(appointment)
    end
  end
end
