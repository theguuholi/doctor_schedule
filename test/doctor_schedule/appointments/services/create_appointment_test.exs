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
    date =
      Timex.now()
      |> Timex.shift(days: 1)
      |> Timex.to_naive_datetime()

    date =
      %NaiveDateTime{date | hour: 17}
      |> NaiveDateTime.to_iso8601()

    assert {:error, "You cannot create an appointment to yourself"} ==
             CreateAppointment.execute(%{
               "date" => date,
               "provider_id" => 123,
               "user_id" => 123
             })
  end

  test "it should throw an error when the booking is outside schedule" do
    date =
      Timex.now()
      |> Timex.shift(days: 1)
      |> Timex.to_naive_datetime()

    date =
      %NaiveDateTime{date | hour: 20}
      |> NaiveDateTime.to_iso8601()

    assert {:error, "You can book between 8am until 19pm"} ==
             CreateAppointment.execute(%{
               "date" => date,
               "provider_id" => 1232,
               "user_id" => 123
             })
  end

  test "it should throw an error when has a schedule booked" do
    date =
      Timex.now()
      |> Timex.shift(days: 1)
      |> Timex.to_naive_datetime()

    date =
      %NaiveDateTime{date | hour: 17}
      |> NaiveDateTime.to_iso8601()

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

    date =
      Timex.now()
      |> Timex.shift(days: 1)
      |> Timex.to_naive_datetime()

    date =
      %NaiveDateTime{date | hour: 17}
      |> NaiveDateTime.to_iso8601()

    {:ok, scheduled} =
      CreateAppointment.execute(%{
        "date" => date,
        "provider_id" => provider.id,
        "user_id" => user.id
      })

    assert user.id == scheduled.user_id
  end
end
