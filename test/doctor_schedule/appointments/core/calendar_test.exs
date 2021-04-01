defmodule DoctorSchedule.Appointments.Core.CalendarTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Appointments.Core.Calendar
  alias DoctorSchedule.UserFixture

  test "should create a calendar" do
    user = UserFixture.create_user()
    assert true == Calendar.new(Timex.now(), user.id).is_today
  end

  test "should create a for the next_month" do
    user = UserFixture.create_user()
    assert false == Calendar.calendar_event(Timex.now(), user.id, :next_month).is_today
  end

  test "should create a for  previous_month" do
    user = UserFixture.create_user()
    assert false == Calendar.calendar_event(Timex.now(), user.id, :previous_month).is_today
  end

  test "should create a calendar not being today" do
    user = UserFixture.create_user()
    date = Timex.now() |> Timex.shift(days: 1)
    assert false == Calendar.new(date, user.id).is_today
  end
end
