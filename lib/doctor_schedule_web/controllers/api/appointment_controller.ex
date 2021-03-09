defmodule DoctorScheduleWeb.Api.AppointmentController do
  use DoctorScheduleWeb, :controller

  alias DoctorSchedule.Appointments.Entities.Appointment
  alias DoctorSchedule.Appointments.Repositories.AppointmentsRepository
  alias DoctorSchedule.Appointments.Services.CreateAppointment

  action_fallback DoctorScheduleWeb.FallbackController

  def index(conn, _params) do
    appointments = AppointmentsRepository.list_appointments()
    render(conn, "index.json", appointments: appointments)
  end

  def create(conn, %{"appointment" => appointment_params}) do
    user = Guardian.Plug.current_resource(conn)

    appointment_params =
      appointment_params
      |> Map.put("user_id", user.id)

    with {:ok, %Appointment{} = appointment} <-
           CreateAppointment.execute(appointment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_appointment_path(conn, :show, appointment))
      |> render("show.json", appointment: appointment)
    end
  end

  def show(conn, %{"id" => id}) do
    appointment = AppointmentsRepository.get_appointment!(id)
    render(conn, "show.json", appointment: appointment)
  end

  def update(conn, %{"id" => id, "appointment" => appointment_params}) do
    appointment = AppointmentsRepository.get_appointment!(id)

    with {:ok, %Appointment{} = appointment} <-
           AppointmentsRepository.update_appointment(appointment, appointment_params) do
      render(conn, "show.json", appointment: appointment)
    end
  end

  def delete(conn, %{"id" => id}) do
    appointment = AppointmentsRepository.get_appointment!(id)

    with {:ok, %Appointment{}} <- AppointmentsRepository.delete_appointment(appointment) do
      send_resp(conn, :no_content, "")
    end
  end
end
