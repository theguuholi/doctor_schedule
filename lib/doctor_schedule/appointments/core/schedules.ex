defmodule DoctorSchedule.Appointments.Core.Schedules do
  defstruct morning_appointments: nil, afternoon_apointments: nil
  alias DoctorSchedule.Appointments.Repositories.ProviderRepository

  def get_all_appointments(current_date, current_user_id) do
    current_date = Timex.to_date(current_date)
    schedules = ProviderRepository.all_day_fom_provider(current_user_id, current_date)
    morning_appointments = Enum.filter(schedules, &(&1.date.hour < 12))
    afternoon_apointments = Enum.filter(schedules, &(&1.date.hour >= 12))

    %__MODULE__{
      morning_appointments: morning_appointments,
      afternoon_apointments: afternoon_apointments
    }
  end
end
