defmodule DoctorScheduleWeb.ForgotPasswordController do
  use DoctorScheduleWeb, :controller
  alias DoctorSchedule.Accounts.Entities.User
  alias DoctorSchedule.Accounts.Services.CreateUser
  alias DoctorScheduleWeb.Auth.Guardian

  def forgot_password(conn, params) do
    # changeset = User.changeset_login(%User{})
    render(conn, "index.html")
  end
end
