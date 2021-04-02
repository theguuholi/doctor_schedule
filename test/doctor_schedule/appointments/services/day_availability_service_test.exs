defmodule DoctorSchedule.Appointments.Services.DayAvailabilityServiceTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Appointments.Services.DayAvailabilityService
  alias DoctorSchedule.Shared.Cache.Ets.Implementations.ScheduleCache
  alias DoctorSchedule.UserFixture

  import Mock

  @result [
    %{available: false, hour: 8},
    %{available: false, hour: 9},
    %{available: false, hour: 10},
    %{available: false, hour: 11},
    %{available: false, hour: 12},
    %{available: false, hour: 13},
    %{available: false, hour: 14},
    %{available: false, hour: 15},
    %{available: false, hour: 16},
    %{available: false, hour: 17},
    %{available: false, hour: 18},
    %{available: false, hour: 19}
  ]

  test "it should see all available hour with and without cache" do
    provider = UserFixture.create_provider()
    date = Timex.now() |> Timex.shift(days: -1) |> Timex.to_date()

    with_mock Redix, command: fn _, _ -> {:ok, nil} end do
      response = DayAvailabilityService.execute(provider.id, date)
      assert @result == response
    end
  end

  test "it should see all available hour with and with cache" do
    provider = UserFixture.create_provider()
    date = Date.utc_today()
    date = %Date{date | day: date.day - 1}

    with_mock ScheduleCache, get: fn _ -> {:ok, @result} end do
      response = DayAvailabilityService.execute(provider.id, date)
      assert @result == response
    end
  end
end
