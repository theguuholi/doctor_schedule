defmodule DoctorSchedule.Accounts.Services.SendForgotPasswordToEmail do
  use Bamboo.Phoenix, view: DoctorScheduleWeb.EmailView

  import Bamboo.Email

  alias DoctorSchedule.Accounts.Repositories.TokenRepository
  alias DoctorSchedule.Shared.MailProvider.Mailer

  @host "http://localhost:4000"

  def execute(email) do
    TokenRepository.generate(email)
    |> case do
      {:error, msg} ->
        {:error, msg}

      {:ok, token, user} ->
        Task.async(fn -> send_email(token, user) end)
        {:ok, user, token}
    end
  end

  def send_email(token, user) do
    url = "#{@host}/reset-password/#{token}"

    new_email()
    |> from({"Doctor Schedule Team", "adm@doctorschedule.com"})
    |> to({user.first_name, user.email})
    |> subject("[DOCTOR SCHEDULE] - Recuperacao de Senha ")
    |> assign(:data, %{name: user.first_name, url: url})
    |> render("password_forgot.html")
    |> Mailer.deliver_now()
  end
end
