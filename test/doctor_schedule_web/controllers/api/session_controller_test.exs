defmodule DoctorScheduleWeb.Api.SessionControllerTest do
  use DoctorScheduleWeb.ConnCase

  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.UserFixture

  import DoctorScheduleWeb.Auth.Guardian

  def fixture(:user) do
    {:ok, user} = AccountRepository.create_user(UserFixture.valid_user())
    user
  end

  setup %{conn: conn} do
    {:ok, user} =
      %{
        email: "auth@test",
        first_name: "some first_name",
        last_name: "some last_name",
        password: "some password_hash",
        password_confirmation: "some password_hash"
      }
      |> AccountRepository.create_user()

    {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer " <> token)

    {:ok, conn: conn}
  end

  describe "session tests" do
    test "should authenticate with valid user", %{conn: conn} do
      conn =
        conn
        |> post(Routes.api_session_path(conn, :create), %{
          email: "auth@test",
          password: "some password_hash"
        })

      assert json_response(conn, 201)["user"]["email"] == "auth@test"
    end

    test "should not authenticate with invalid user", %{conn: conn} do
      conn =
        conn
        |> post(Routes.api_session_path(conn, :create), %{
          email: "auth@test",
          password: "12312312312"
        })

      assert json_response(conn, 400) == %{"message" => "unauthorized"}
    end
  end
end
