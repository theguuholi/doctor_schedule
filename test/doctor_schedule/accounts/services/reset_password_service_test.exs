defmodule DoctorSchedule.Accounts.Services.ResetPasswordServiceTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Accounts.Repositories.TokenRepository
  alias DoctorSchedule.Accounts.Services.ResetPasswordService

  alias DoctorSchedule.UserFixture

  import Mock

  test "execute/2 should reset password " do
    user = UserFixture.create_user()

    {:ok, token, _} = TokenRepository.generate(user.email)

    assert {:ok, "Password has updated!"} ==
             ResetPasswordService.execute(token, %{
               password: "121212",
               password_confirmation: "121212"
             })
  end

  test "execute/2 should return error token expired" do
    user = UserFixture.create_user()

    {:ok, token, _} = TokenRepository.generate(user.email)
    now = DateTime.utc_now()
    future_date = %{now | hour: now.hour + 5}

    with_mock DateTime, utc_now: fn -> future_date end do
      assert {:error, "Token has expired!"} ==
               ResetPasswordService.execute(token, %{
                 password: "121212",
                 password_confirmation: "121212"
               })
    end
  end

  test "execute/2 should retrieve error token does not exist " do
    assert {:error, "Token does not exist!"} ==
             ResetPasswordService.execute("16cdecdc-647b-461f-9b4f-4a6dcc97b4da", %{
               password: "121212",
               password_confirmation: "121212"
             })
  end
end
