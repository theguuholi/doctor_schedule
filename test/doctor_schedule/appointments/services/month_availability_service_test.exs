defmodule DoctorSchedule.Appointments.Services.MonthAvailabilityServiceTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Appointments.Repositories.AppointmentsRepository
  alias DoctorSchedule.Appointments.Services.MonthAvailabilityService
  alias DoctorSchedule.UserFixture

  import Mock

  test "it should see all available month" do
    provider = UserFixture.create_provider()
    response = MonthAvailabilityService.execute(provider.id, 2019, 12)

    assert [
             %{available: false, day: 1},
             %{available: false, day: 2},
             %{available: false, day: 3},
             %{available: false, day: 4},
             %{available: false, day: 5},
             %{available: false, day: 6},
             %{available: false, day: 7},
             %{available: false, day: 8},
             %{available: false, day: 9},
             %{available: false, day: 10},
             %{available: false, day: 11},
             %{available: false, day: 12},
             %{available: false, day: 13},
             %{available: false, day: 14},
             %{available: false, day: 15},
             %{available: false, day: 16},
             %{available: false, day: 17},
             %{available: false, day: 18},
             %{available: false, day: 19},
             %{available: false, day: 20},
             %{available: false, day: 21},
             %{available: false, day: 22},
             %{available: false, day: 23},
             %{available: false, day: 24},
             %{available: false, day: 25},
             %{available: false, day: 26},
             %{available: false, day: 27},
             %{available: false, day: 28},
             %{available: false, day: 29},
             %{available: false, day: 30},
             %{available: false, day: 31}
           ] == response
  end

  test "it should see all available month with schedules" do
    provider = UserFixture.create_provider()
    user = UserFixture.create_user()

    with_mocks [
      {Date, [:passthrough], [utc_today: fn -> ~D[2020-12-12] end]}
    ] do
      create_appointment_list(provider.id, user.id)

      response = MonthAvailabilityService.execute(provider.id, 2020, 12)

      assert [
               %{available: false, day: 1},
               %{available: false, day: 2},
               %{available: false, day: 3},
               %{available: false, day: 4},
               %{available: false, day: 5},
               %{available: false, day: 6},
               %{available: false, day: 7},
               %{available: false, day: 8},
               %{available: false, day: 9},
               %{available: false, day: 10},
               %{available: false, day: 11},
               %{available: true, day: 12},
               %{available: true, day: 13},
               %{available: false, day: 14},
               %{available: true, day: 15},
               %{available: true, day: 16},
               %{available: true, day: 17},
               %{available: true, day: 18},
               %{available: true, day: 19},
               %{available: true, day: 20},
               %{available: true, day: 21},
               %{available: true, day: 22},
               %{available: true, day: 23},
               %{available: true, day: 24},
               %{available: true, day: 25},
               %{available: true, day: 26},
               %{available: true, day: 27},
               %{available: true, day: 28},
               %{available: true, day: 29},
               %{available: true, day: 30},
               %{available: true, day: 31}
             ] == response
    end
  end

  defp create_appointment_list(provider_id, user_id) do
    date_list()
    |> Enum.each(fn date ->
      %{
        date: date,
        provider_id: provider_id,
        user_id: user_id
      }
      |> AppointmentsRepository.create_appointment()
    end)
  end

  defp date_list do
    [
      ~N[2020-12-14 08:00:00],
      ~N[2020-12-14 09:00:00],
      ~N[2020-12-14 10:00:00],
      ~N[2020-12-14 11:00:00],
      ~N[2020-12-14 12:00:00],
      ~N[2020-12-14 13:00:00],
      ~N[2020-12-14 14:00:00],
      ~N[2020-12-14 15:00:00],
      ~N[2020-12-14 16:00:00],
      ~N[2020-12-14 17:00:00],
      ~N[2020-12-14 18:00:00],
      ~N[2020-12-14 19:00:00],
      ~N[2020-12-14 20:00:00]
    ]
  end
end
