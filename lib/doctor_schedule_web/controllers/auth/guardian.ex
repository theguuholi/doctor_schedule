defmodule DoctorScheduleWeb.Auth.Guardian do
  use Guardian, otp_app: :doctor_schedule

  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.Accounts.Services.Session

  def subject_for_token(user, _claims), do: {:ok, to_string(user.id)}

  def resource_from_claims(claims) do
    user =
      claims["sub"]
      |> AccountRepository.get_user!()

    {:ok, user}
  end

  def authenticate(email, password) do
    case Session.authenticate(email, password) do
      {:ok, user} ->
        create_token(user)

      _ ->
        {:error, :unauthorized}
    end
  end

  defp create_token(user) do
    {:ok, token, _claim} = encode_and_sign(user)
    {:ok, user, token}
  end
end
