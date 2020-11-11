defmodule DoctorScheduleWeb.Auth.Pipeline do
  alias DoctorScheduleWeb.Auth

  use Guardian.Plug.Pipeline,
    otp_app: :doctor_schedule,
    module: Auth.Guardian,
    error_handler: Auth.ErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug Guardian.Plug.EnsureAuthenticated
end
