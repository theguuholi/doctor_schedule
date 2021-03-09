defmodule DoctorSchedule.Accounts.Repositories.SessionTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Accounts.Services.Session

  alias DoctorSchedule.UserFixture

  test "authenticate/2 should return user" do
    UserFixture.create_user()

    {:ok, user_authenticate} = Session.authenticate("test@test", "some password_hash")
    assert "test@test" == user_authenticate.email
  end

  test "authenticate/2 unauthorized password invalid" do
    UserFixture.create_user()

    assert {:error, :unauthorized} == Session.authenticate("test@test", "some 434343")
  end

  test "authenticate/2 should return not_found" do
    result = Session.authenticate("test@eqewqe", "some password_hash")
    assert {:error, :not_found} == result
  end
end
