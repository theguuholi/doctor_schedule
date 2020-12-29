defmodule DoctorSchedule.Accounts.Services.ListProvidersTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Accounts.Services.ListProviders

  test "list providers with and without cache" do
    assert [] == ListProviders.execute()
    assert [] == ListProviders.execute()
  end
end
