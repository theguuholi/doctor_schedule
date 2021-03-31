defmodule DoctorSchedule.AppointmentsApiTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Appointments
  alias DoctorSchedule.UserFixture

  test "should create a calendar" do
    user = UserFixture.create_user()
    assert true == Appointments.create_calendar(Timex.now(), user.id).is_today
  end

  test "should create a for the next_month" do
    user = UserFixture.create_user()
    assert false == Appointments.calendar_event(Timex.now(), user.id, :next_month).is_today
  end
end
