defmodule DoctorScheduleWeb.ForgotPasswordControllerTest do
  use DoctorScheduleWeb.ConnCase

  alias DoctorSchedule.UserFixture

  test "should test forgot password page", %{conn: conn} do
    assert conn
           |> get(Routes.forgot_password_path(conn, :forgot_password))
           |> html_response(200) =~ "Recuperar senha"
  end

  test "should test recover password", %{conn: conn} do
    user = UserFixture.create_user()

    conn =
      conn
      |> post(Routes.forgot_password_path(conn, :forgot_password_create),
        user: %{"email" => user.email}
      )

    assert redirected_to(conn) == Routes.session_path(conn, :session)
    conn = get(conn, Routes.session_path(conn, :session))
    assert html_response(conn, 200) =~ "Basta clicar no botao abaixo"
  end

  test "should throw error when recover password", %{conn: conn} do
    conn =
      conn
      |> post(Routes.forgot_password_path(conn, :forgot_password_create),
        user: %{"email" => "test@test"}
      )

    assert redirected_to(conn) == Routes.session_path(conn, :session)
    conn = get(conn, Routes.session_path(conn, :session))
    assert html_response(conn, 200) =~ "User does not exists"
  end
end
