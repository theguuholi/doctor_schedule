defmodule DoctorScheduleWeb.HeaderComponent do
  use Phoenix.LiveComponent
  alias DoctorScheduleWeb.PageView
  alias Phoenix.View

  def render(assigns) do
    View.render(PageView, "header.html", assigns)
  end
end
