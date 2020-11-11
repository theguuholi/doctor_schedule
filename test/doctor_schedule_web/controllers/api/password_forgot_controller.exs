defmodule DoctorScheduleWeb.Api.PasswordForgotControllerTest do
  use DoctorScheduleWeb.ConnCase

  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.UserFixture

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  test "should send email to forgot password", %{conn: conn} do
    {:ok, user} = AccountRepository.create_user(UserFixture.valid_user())

    conn =
      conn
      |> post(Routes.api_password_forgot_path(conn, :create), email: user.email)

    assert conn.status == 204
  end
end
