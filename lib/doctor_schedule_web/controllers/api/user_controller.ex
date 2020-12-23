defmodule DoctorScheduleWeb.Api.UserController do
  use DoctorScheduleWeb, :controller

  alias DoctorSchedule.Accounts.Entities.User
  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.Accounts.Services.CreateUser
  alias DoctorSchedule.Accounts.Services.ListProviders

  action_fallback DoctorScheduleWeb.FallbackController

  def index(conn, params) do
    users =
      params["only_providers"]
      |> get_users()

    render(conn, "index.json", users: users)
  end

  defp get_users("1"), do: ListProviders.execute()
  defp get_users(_), do: AccountRepository.list_users()

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- CreateUser.execute(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = AccountRepository.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = AccountRepository.get_user!(id)

    with {:ok, %User{} = user} <- AccountRepository.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = AccountRepository.get_user!(id)

    with {:ok, %User{}} <- AccountRepository.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
