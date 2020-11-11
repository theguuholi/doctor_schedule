defmodule DoctorSchedule.Accounts.Repositories.SessionTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.Accounts.Services.Session

  alias DoctorSchedule.UserFixture

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(UserFixture.valid_user())
      |> AccountRepository.create_user()

    user
  end

  test "authenticate/2 should return user" do
    user_fixture()
    {:ok, user_authenticate} = Session.authenticate("test@test", "some password_hash")
    assert "test@test" == user_authenticate.email
  end

  test "authenticate/2 unauthorized password invalid" do
    user_fixture()
    assert {:error, :unauthorized} == Session.authenticate("test@test", "some 434343")
  end

  test "authenticate/2 should return not_found" do
    result = Session.authenticate("test@eqewqe", "some password_hash")
    assert {:error, :not_found} == result
  end
end
