defmodule DoctorScheduleWeb.Api.AppointmentControllerTest do
  use DoctorScheduleWeb.ConnCase

  import DoctorScheduleWeb.Auth.Guardian

  alias DoctorSchedule.AppointmentFixture
  alias DoctorSchedule.Appointments.Entities.Appointment
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

  describe "index" do
    test "lists all appointments", %{conn: conn} do
      conn = get(conn, Routes.api_appointment_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create appointment" do
    test "renders appointment when data is valid", %{conn: conn} do
      provider = UserFixture.create_provider()

      date =
        Timex.now()
        |> Timex.shift(days: 1)
        |> Timex.to_naive_datetime()

      date =
        %NaiveDateTime{date | hour: 17}
        |> NaiveDateTime.to_iso8601()

      conn =
        post(conn, Routes.api_appointment_path(conn, :create),
          appointment: %{date: date, provider_id: provider.id}
        )

      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.api_appointment_path(conn, :show, id))

      assert id == json_response(conn, 200)["id"]
    end
  end

  describe "update appointment" do
    setup [:create_appointment]

    test "renders appointment when data is valid", %{
      conn: conn,
      appointment: %Appointment{id: id} = appointment
    } do
      now = DateTime.utc_now()

      conn =
        put(conn, Routes.api_appointment_path(conn, :update, appointment),
          appointment: %{date: now}
        )

      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.api_appointment_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => now
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, appointment: appointment} do
      conn =
        put(conn, Routes.api_appointment_path(conn, :update, appointment),
          appointment: %{date: nil}
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete appointment" do
    setup [:create_appointment]

    test "deletes chosen appointment", %{conn: conn, appointment: appointment} do
      conn = delete(conn, Routes.api_appointment_path(conn, :delete, appointment))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_appointment_path(conn, :show, appointment))
      end
    end
  end

  defp create_appointment(setup_conn) do
    user_id = setup_conn.user_id
    %{appointment: AppointmentFixture.appointment_fixture(user_id)}
  end
end
