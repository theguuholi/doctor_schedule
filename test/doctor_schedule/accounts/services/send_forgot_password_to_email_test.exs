defmodule DoctorSchedule.Accounts.Services.SendForgotPasswordToEmailTest do
  use DoctorSchedule.DataCase
  use Bamboo.Test

  alias DoctorSchedule.Accounts.Services.SendForgotPasswordToEmail

  alias DoctorSchedule.UserFixture

  test "execute/1 should reset password " do
    user = UserFixture.create_user()

    {:ok, user_response, _token} = SendForgotPasswordToEmail.execute(user.email)
    assert user_response.id == user.id
  end

  test "send_email/2 should reset password " do
    sent_email =
      SendForgotPasswordToEmail.send_email(
        "123123123",
        %{first_name: "123", email: "123"}
      )

    assert sent_email.to == [{"123", "123"}]
    assert sent_email.html_body =~ "Ola!"
    assert sent_email.from == {"Doctor Schedule Team", "adm@doctorschedule.com"}
    assert_delivered_email(sent_email)
  end

  test "execute/2 should reset password no success " do
    assert {:error, "User does not exists"} == SendForgotPasswordToEmail.execute("ornitorinco")
  end
end
