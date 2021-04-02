defmodule DoctorScheduleWeb.ScheduleComponent do
  use Phoenix.LiveComponent
  alias DoctorScheduleWeb.PageView
  alias Phoenix.View

  def render(assigns) do
    View.render(PageView, "schedule.html", assigns)
  end
end
