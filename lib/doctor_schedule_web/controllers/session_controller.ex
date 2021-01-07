defmodule DoctorScheduleWeb.SessionController do
  use DoctorScheduleWeb, :controller
  alias DoctorSchedule.Accounts.Entities.User

  def session(conn, _params) do
    changeset = User.changeset_login(%User{})
    render(conn, "session.html", changeset: changeset, action: "/" )
  end
end
