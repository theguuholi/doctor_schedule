defmodule DoctorSchedule.Appointments.Services.CreateAppointmentTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Appointments.Repositories.AppointmentsRepository
  alias DoctorSchedule.Appointments.Services.CreateAppointment
  alias DoctorSchedule.UserFixture

  import Mock

  test "it should throw an error when date is in the past" do
    assert {:error, "You cannot create an appointment in the past"} ==
             CreateAppointment.execute(%{
               "date" => NaiveDateTime.utc_now() |> NaiveDateTime.to_string(),
               "provider_id" => 123,
               "user_id" => 123
             })
  end

  test "it should throw an error when doctor has the same id from user" do
    date = NaiveDateTime.utc_now()

    date =
      %NaiveDateTime{date | day: date.day + 1}
      |> NaiveDateTime.to_string()

    assert {:error, "You cannot create an appointment to yourself"} ==
             CreateAppointment.execute(%{
               "date" => date,
               "provider_id" => 123,
               "user_id" => 123
             })
  end

  test "it should throw an error when the booking is outside schedule" do
    date = NaiveDateTime.utc_now()

    date =
      %NaiveDateTime{date | day: date.day + 1, hour: 20}
      |> NaiveDateTime.to_string()

    assert {:error, "You can book between 8am until 19pm"} ==
             CreateAppointment.execute(%{
               "date" => date,
               "provider_id" => 1232,
               "user_id" => 123
             })
  end

  test "it should throw an error when has a schedule booked" do
    date = NaiveDateTime.utc_now()

    date =
      %NaiveDateTime{date | day: date.day + 1, hour: 17}
      |> NaiveDateTime.to_string()

    with_mocks [
      {AppointmentsRepository, [],
       [find_by_appointment_date_and_provider: fn _, _ -> "passou no teste" end]}
    ] do
      assert {:error, "This appointment is already booked"} ==
               CreateAppointment.execute(%{
                 "date" => date,
                 "provider_id" => 1232,
                 "user_id" => 123
               })
    end
  end

  test "it should create a book to a doctor" do
    user = UserFixture.create_user()
    provider = UserFixture.create_provider()
    date = NaiveDateTime.utc_now()

    date =
      %NaiveDateTime{date | day: date.day + 1, hour: 12}
      |> NaiveDateTime.to_string()

    {:ok, scheduled} =
      CreateAppointment.execute(%{
        "date" => date,
        "provider_id" => provider.id,
        "user_id" => user.id
      })

    assert user.id == scheduled.user_id
  end
end
