defmodule DoctorScheduleWeb.SessionController do
  use DoctorScheduleWeb, :controller

  def session(conn, _params) do
    render(conn, "session.html")
  end
end
