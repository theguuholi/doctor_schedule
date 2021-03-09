defmodule DoctorScheduleWeb.Api.AppointmentView do
  use DoctorScheduleWeb, :view
  alias DoctorScheduleWeb.Api.AppointmentView

  def render("index.json", %{appointments: appointments}) do
    render_many(appointments, AppointmentView, "appointment.json")
  end

  def render("show.json", %{appointment: appointment}) do
    render_one(appointment, AppointmentView, "appointment.json")
  end

  def render("appointment.json", %{appointment: appointment}) do
    %{id: appointment.id, date: appointment.date}
  end
end
