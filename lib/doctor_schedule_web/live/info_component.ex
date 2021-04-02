defmodule DoctorScheduleWeb.InfoComponent do
  use Phoenix.LiveComponent
  alias DoctorScheduleWeb.PageView
  alias Phoenix.View

  def render(assigns) do
    View.render(PageView, "info.html", assigns)
  end
end
