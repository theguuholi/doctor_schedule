defmodule DoctorSchedule.Accounts.Services.Session do
  alias DoctorSchedule.Accounts.Entities.User
  alias DoctorSchedule.Repo

  def authenticate(email, password) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :not_found}

      user ->
        if Argon2.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end
end
