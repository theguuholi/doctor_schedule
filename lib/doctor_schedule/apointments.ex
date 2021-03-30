defmodule DoctorSchedule.Appointments do
  alias DoctorSchedule.Appointments.Core.Calendar

  def create_calendar(current_date) do
    Calendar.new(current_date)
  end

  def calendar_event(current_date, event) do
    Calendar.calendar_event(current_date, event)
  end
end
