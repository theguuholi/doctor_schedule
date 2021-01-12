defmodule DoctorScheduleWeb.SessionController do
  use DoctorScheduleWeb, :controller
  alias DoctorSchedule.Accounts.Entities.User
  alias DoctorSchedule.Accounts.Services.CreateUser
  alias DoctorScheduleWeb.Auth.Guardian

  def session(conn, _params) do
    changeset = User.changeset_login(%User{})
    changeset_insert = User.changeset(%User{})

    render(conn, "session.html",
      changeset: changeset,
      changeset_insert: changeset_insert,
      action: Routes.session_path(conn, :login_create)
    )
  end

  def login_create(conn, %{"user" => user_params}) do
    Guardian.authenticate(user_params["email"], user_params["password"])
    |> case do
      {:ok, user, _token} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Logado com sucesso!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, :unauthorized} ->
        changeset = User.changeset_login(%User{}, user_params)
        changeset = %{changeset | action: :login}

        conn
        |> put_flash(:error, "Usuario e/ou senha invalido!")
        |> render("session.html",
          changeset: changeset,
          action: Routes.session_path(conn, :login_create)
        )
    end
  end

  def create_account(conn, %{"user" => user_params}) do
    user_params
    |> CreateUser.execute()
    |> case do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Cadastrado com Sucesso! ")
        |> redirect(to: Routes.session_path(conn, :session))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Usuario e/ou senha invalido!")
        |> render("session.html",
          changeset_insert: changeset,
          action: Routes.session_path(conn, :session)
        )
    end
  end
end
