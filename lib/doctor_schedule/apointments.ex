defmodule DoctorSchedule.Appointments do
  alias DoctorSchedule.Appointments.Core.Calendar

  def create_calendar(current_date) do
    Calendar.create(current_date)
  end
end
