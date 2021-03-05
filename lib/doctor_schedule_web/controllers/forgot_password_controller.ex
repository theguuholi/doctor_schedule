defmodule DoctorScheduleWeb.ForgotPasswordController do
  use DoctorScheduleWeb, :controller
  alias DoctorSchedule.Accounts.Entities.User
  alias DoctorSchedule.Accounts.Services.SendForgotPasswordToEmail

  def forgot_password(conn, _params) do
    changeset = User.changeset_password_forgot(%User{})

    render(conn, "index.html",
      changeset: changeset,
      action: Routes.forgot_password_path(conn, :forgot_password_create)
    )
  end

  def forgot_password_create(conn, %{"user" => %{"email" => email}}) do
    email
    |> SendForgotPasswordToEmail.execute()
    |> case do
      {:ok, _user, _token} ->
        conn
        |> put_flash(
          :info,
          "Enviamos um e-mail para confirmar a recuperacao de senha, cheque a sua caixa de entrada"
        )
        |> redirect(to: Routes.session_path(conn, :session))

      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.session_path(conn, :session))
    end
  end
end
