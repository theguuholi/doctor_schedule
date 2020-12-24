defmodule DoctorSchedule.Accounts.Services.CreateUserTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Accounts.Services.CreateUser

  test "it should create a user with and without cache" do
    user_admin = %{
      "email" => "9@3.com",
      "first_name" => "5@3.com",
      "last_name" => "5@3.com",
      "password" => "5@3.com",
      "password_confirmation" => "5@3.com",
      "role" => "admin"
    }

    {:ok, user} = CreateUser.execute(user_admin)

    assert user.email == "9@3.com"
  end
end
