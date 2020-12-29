defmodule DoctorScheduleWeb.Api.ProviderDayAvailabilityControlerTest do
  use DoctorScheduleWeb.ConnCase

  import DoctorScheduleWeb.Auth.Guardian

  alias DoctorSchedule.UserFixture

  setup %{conn: conn} do
    user = UserFixture.create_user()
    {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer " <> token)

    {:ok, conn: conn, user_id: user.id}
  end

  import Mock

  test "should list provider", %{conn: conn} do
    provider = UserFixture.create_provider()

    with_mock Redix, command: fn _, _ -> {:ok, nil} end do
      conn =
        get(
          conn,
          Routes.api_provider_day_availability_path(conn, :show, provider.id, "2020-04-01")
        )

      assert json_response(conn, 200) == [
               %{"available" => false, "hour" => 8},
               %{"available" => false, "hour" => 9},
               %{"available" => false, "hour" => 10},
               %{"available" => false, "hour" => 11},
               %{"available" => false, "hour" => 12},
               %{"available" => false, "hour" => 13},
               %{"available" => false, "hour" => 14},
               %{"available" => false, "hour" => 15},
               %{"available" => false, "hour" => 16},
               %{"available" => false, "hour" => 17},
               %{"available" => false, "hour" => 18},
               %{"available" => false, "hour" => 19}
             ]
    end
  end
end
