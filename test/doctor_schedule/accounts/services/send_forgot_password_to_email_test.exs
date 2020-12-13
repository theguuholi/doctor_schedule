defmodule DoctorSchedule.Accounts.Services.SendForgotPasswordToEmailTest do
  use DoctorSchedule.DataCase
  use Bamboo.Test

  alias DoctorSchedule.Accounts.Services.SendForgotPasswordToEmail

  alias DoctorSchedule.UserFixture

  test "execute/2 should reset password " do
    user = UserFixture.create_user()

    {:ok, _user, _token, sent_email} = SendForgotPasswordToEmail.execute(user.email)
    assert sent_email.to == [{"some first_name", "test@test"}]
    assert sent_email.html_body =~ "Ola!"
    assert sent_email.from == {"Doctor Schedule Team", "adm@doctorschedule.com"}
    assert_delivered_email(sent_email)
  end

  test "execute/2 should reset password no success " do
    assert {:error, "User does not exists"} == SendForgotPasswordToEmail.execute("ornitorinco")
  end
end
