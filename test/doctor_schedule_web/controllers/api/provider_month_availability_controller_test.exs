defmodule DoctorScheduleWeb.Api.ProviderMonthAvailabilityControlerTest do
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

  test "should list provider", %{conn: conn} do
    provider = UserFixture.create_provider()

    conn =
      get(conn, Routes.api_provider_month_availability_path(conn, :show, provider.id), %{
        year: 2020,
        month: 04
      })

    assert json_response(conn, 200) == [
             %{"available" => false, "day" => 1},
             %{"available" => false, "day" => 2},
             %{"available" => false, "day" => 3},
             %{"available" => false, "day" => 4},
             %{"available" => false, "day" => 5},
             %{"available" => false, "day" => 6},
             %{"available" => false, "day" => 7},
             %{"available" => false, "day" => 8},
             %{"available" => false, "day" => 9},
             %{"available" => false, "day" => 10},
             %{"available" => false, "day" => 11},
             %{"available" => false, "day" => 12},
             %{"available" => false, "day" => 13},
             %{"available" => false, "day" => 14},
             %{"available" => false, "day" => 15},
             %{"available" => false, "day" => 16},
             %{"available" => false, "day" => 17},
             %{"available" => false, "day" => 18},
             %{"available" => false, "day" => 19},
             %{"available" => false, "day" => 20},
             %{"available" => false, "day" => 21},
             %{"available" => false, "day" => 22},
             %{"available" => false, "day" => 23},
             %{"available" => false, "day" => 24},
             %{"available" => false, "day" => 25},
             %{"available" => false, "day" => 26},
             %{"available" => false, "day" => 27},
             %{"available" => false, "day" => 28},
             %{"available" => false, "day" => 29},
             %{"available" => false, "day" => 30}
           ]
  end
end
