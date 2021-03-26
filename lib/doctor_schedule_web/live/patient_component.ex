defmodule DoctorScheduleWeb.PatientComponent do
  use Phoenix.LiveComponent
  alias DoctorScheduleWeb.PageView
  alias Phoenix.View

  def render(assigns) do
    View.render(PageView, "patient.html", assigns)
  end
end
