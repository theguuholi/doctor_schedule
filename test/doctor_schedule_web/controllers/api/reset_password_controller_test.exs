defmodule DoctorScheduleWeb.Api.ResetPasswordControllerTest do
  use DoctorScheduleWeb.ConnCase

  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.Accounts.Services.SendForgotPasswordToEmail
  alias DoctorSchedule.UserFixture

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  test "should reset password", %{conn: conn} do
    {:ok, user} = AccountRepository.create_user(UserFixture.valid_user())
    {:ok, _, token} = SendForgotPasswordToEmail.execute(user.email)

    conn =
      conn
      |> post(Routes.api_reset_password_path(conn, :create), %{
        data: %{password: "123123", password_confirmation: "123123"},
        token: token
      })

    assert conn.status == 204
  end
end
