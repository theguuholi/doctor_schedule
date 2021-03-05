defmodule DoctorScheduleWeb.ForgotPasswordController do
  use DoctorScheduleWeb, :controller
  alias DoctorSchedule.Accounts.Entities.User

  def forgot_password(conn, _params) do
    changeset = User.changeset_password_forgot(%User{})
    render(conn, "index.html", changeset: changeset, action: "/")
  end
end
