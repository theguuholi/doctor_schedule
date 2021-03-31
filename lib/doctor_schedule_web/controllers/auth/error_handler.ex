defmodule DoctorScheduleWeb.Auth.ErrorHandler do
  use DoctorScheduleWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    conn.request_path
    |> String.contains?("api")
    |> error_page(conn, type)
  end

  defp error_page(true, conn, type) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{error: to_string(type)}))
  end

  defp error_page(false, conn, _type) do
    conn
    |> put_flash(:error, "You need to be signed")
    |> redirect(to: Routes.session_path(conn, :session))
  end
end
