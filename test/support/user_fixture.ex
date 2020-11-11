defmodule DoctorSchedule.UserFixture do
  def valid_user,
    do: %{
      email: "test@test",
      first_name: "some first_name",
      last_name: "some last_name",
      password: "some password_hash",
      password_confirmation: "some password_hash"
    }

  def update_user,
    do: %{
      email: "some@updatedemail",
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      password: "some password_hash",
      password_confirmation: "some password_hash"
    }

  def invalid_user,
    do: %{email: nil, first_name: nil, last_name: nil, password_hash: nil, role: nil}
end
