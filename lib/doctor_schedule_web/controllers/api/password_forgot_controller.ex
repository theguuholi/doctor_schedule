defmodule DoctorScheduleWeb.Api.PasswordForgotController do
  use DoctorScheduleWeb, :controller
  alias DoctorSchedule.Accounts.Services.SendForgotPasswordToEmail

  action_fallback DoctorScheduleWeb.FallbackController

  def create(conn, %{"email" => email}) do
    with {:ok, _user, _token} <- SendForgotPasswordToEmail.execute(email) do
      conn
      |> put_status(:no_content)
      |> put_resp_header("content-type", "application/json")
      |> text("")
    end
  end
end
