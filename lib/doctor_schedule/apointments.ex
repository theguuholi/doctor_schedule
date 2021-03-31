defmodule DoctorSchedule.Appointments do
  alias DoctorSchedule.Appointments.Core.Calendar

  def create_calendar(current_date, current_user_id) do
    Calendar.new(current_date, current_user_id)
  end

  def calendar_event(current_date, current_user_id, event) do
    Calendar.calendar_event(current_date, current_user_id, event)
  end
end
