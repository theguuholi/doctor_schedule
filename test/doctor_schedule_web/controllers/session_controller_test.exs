defmodule DoctorScheduleWeb.SessionControllerTest do
  use DoctorScheduleWeb.ConnCase

  alias DoctorSchedule.UserFixture
  alias DoctorScheduleWeb.Auth.Guardian

  test "should test login with success", %{conn: conn} do
    user = UserFixture.create_user()

    conn =
      conn
      |> post(Routes.session_path(conn, :login_create),
        user: %{"email" => user.email, "password" => "some password_hash"}
      )

    assert redirected_to(conn) == Routes.page_path(conn, :index)
    conn = get(conn, Routes.page_path(conn, :index))

    assert html_response(conn, 200) =~ "Logado com sucesso!"
  end

  test "should test logout", %{conn: conn} do
    user = UserFixture.create_user()

    conn =
      conn
      |> Guardian.Plug.sign_in(user)
      |> Plug.Test.init_test_session(current_user: user)
      |> get(Routes.session_path(conn, :logout))

    assert redirected_to(conn) == Routes.session_path(conn, :session)
    conn = get(conn, Routes.session_path(conn, :session))

    assert html_response(conn, 200) =~ "Logar"
  end

  test "should test login page with error", %{conn: conn} do
    assert conn
           |> post(Routes.session_path(conn, :login_create),
             user: %{"email" => "123", "password" => "123"}
           )
           |> html_response(200) =~ "Usuario e/ou senha invalido!"
  end

  test "should test insert user with error", %{conn: conn} do
    assert conn
           |> post(Routes.session_path(conn, :create_account),
             user: %{"email" => "123", "password" => "123"}
           )
           |> html_response(200) =~ "Erro ao cadastrar o usuario!"
  end

  test "should test recover password", %{conn: conn} do
    user = UserFixture.create_user()

    conn =
      conn
      |> post(Routes.session_path(conn, :login_create),
        user: %{"email" => user.email, "password" => "some password_hash"}
      )

    assert redirected_to(conn) == Routes.page_path(conn, :index)
    conn = get(conn, Routes.page_path(conn, :index))
    assert html_response(conn, 200) =~ "Logado com sucesso!"
  end

  test "should test insert user with success", %{conn: conn} do
    user = UserFixture.valid_user()

    conn =
      conn
      |> post(Routes.session_path(conn, :create_account), user: user)

    assert redirected_to(conn) == Routes.session_path(conn, :session)
    conn = get(conn, Routes.session_path(conn, :session))
    assert html_response(conn, 200) =~ "Cadastrado com Sucesso! "
  end
end
