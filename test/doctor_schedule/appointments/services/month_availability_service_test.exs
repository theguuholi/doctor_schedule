defmodule DoctorSchedule.Appointments.Services.MonthAvailabilityServiceTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Appointments.Services.MonthAvailabilityService
  alias DoctorSchedule.UserFixture

  test "it should see all available hour" do
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
end
