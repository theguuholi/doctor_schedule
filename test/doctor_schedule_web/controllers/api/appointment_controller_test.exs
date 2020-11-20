defmodule DoctorScheduleWeb.Api.AppointmentControllerTest do
  use DoctorScheduleWeb.ConnCase

  import DoctorScheduleWeb.Auth.Guardian

  alias DoctorSchedule.Appointments.Entities.Appointment
  alias DoctorSchedule.Appointments.Repositories.AppointmentsRepository
  alias DoctorSchedule.AppointmentFixture
  alias DoctorSchedule.UserFixture

  setup %{conn: conn} do
    {:ok, token, _} = encode_and_sign(UserFixture.create_user(), %{}, token_type: :access)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer " <> token)

    {:ok, conn: conn}
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

      now = NaiveDateTime.utc_now()

      date =
        %NaiveDateTime{now | day: now.day + 1, hour: 10}
        |> NaiveDateTime.to_string()

      conn =
        post(conn, Routes.api_appointment_path(conn, :create),
          appointment: %{date: date, provider_id: provider.id}
        )

      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.api_appointment_path(conn, :show, id))

      assert id = json_response(conn, 200)["id"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_appointment_path(conn, :create), appointment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update appointment" do
    setup [:create_appointment]

    test "renders appointment when data is valid", %{
      conn: conn,
      appointment: %Appointment{id: id} = appointment
    } do
      conn =
        put(conn, Routes.api_appointment_path(conn, :update, appointment),
          appointment: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.api_appointment_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2011-05-18T15:01:01"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, appointment: appointment} do
      conn =
        put(conn, Routes.api_appointment_path(conn, :update, appointment),
          appointment: @invalid_attrs
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

  defp create_appointment(_) do
    %{appointment: AppointmentFixture.appointment_fixture()}
  end
end
