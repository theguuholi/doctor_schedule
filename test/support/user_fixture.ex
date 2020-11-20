defmodule DoctorSchedule.UserFixture do
  alias DoctorSchedule.Accounts.Repositories.AccountRepository

  def valid_user,
    do: %{
      email: "test@test",
      first_name: "some first_name",
      last_name: "some last_name",
      password: "some password_hash",
      password_confirmation: "some password_hash"
    }

  def provider_user,
    do: %{
      email: "provider@test",
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

  def create_user do
    {:ok, user} =
      valid_user()
      |> AccountRepository.create_user()

    user
  end

  def create_provider do
    {:ok, provider} =
      provider_user()
      |> AccountRepository.create_user()

    provider
  end
end
