defmodule DoctorSchedule.AppointmentsTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Appointments

  describe "appointments" do
    alias DoctorSchedule.Appointments.Appointment

    @valid_attrs %{date: ~N[2010-04-17 14:00:00]}
    @update_attrs %{date: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{date: nil}

    def appointment_fixture(attrs \\ %{}) do
      {:ok, appointment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Appointments.create_appointment()

      appointment
    end

    test "list_appointments/0 returns all appointments" do
      appointment = appointment_fixture()
      assert Appointments.list_appointments() == [appointment]
    end

    test "get_appointment!/1 returns the appointment with given id" do
      appointment = appointment_fixture()
      assert Appointments.get_appointment!(appointment.id) == appointment
    end

    test "create_appointment/1 with valid data creates a appointment" do
      assert {:ok, %Appointment{} = appointment} = Appointments.create_appointment(@valid_attrs)
      assert appointment.date == ~N[2010-04-17 14:00:00]
    end

    test "create_appointment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Appointments.create_appointment(@invalid_attrs)
    end

    test "update_appointment/2 with valid data updates the appointment" do
      appointment = appointment_fixture()

      assert {:ok, %Appointment{} = appointment} =
               Appointments.update_appointment(appointment, @update_attrs)

      assert appointment.date == ~N[2011-05-18 15:01:01]
    end

    test "update_appointment/2 with invalid data returns error changeset" do
      appointment = appointment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Appointments.update_appointment(appointment, @invalid_attrs)

      assert appointment == Appointments.get_appointment!(appointment.id)
    end

    test "delete_appointment/1 deletes the appointment" do
      appointment = appointment_fixture()
      assert {:ok, %Appointment{}} = Appointments.delete_appointment(appointment)
      assert_raise Ecto.NoResultsError, fn -> Appointments.get_appointment!(appointment.id) end
    end

    test "change_appointment/1 returns a appointment changeset" do
      appointment = appointment_fixture()
      assert %Ecto.Changeset{} = Appointments.change_appointment(appointment)
    end
  end
end
