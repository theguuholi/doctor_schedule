defmodule DoctorSchedule.Accounts.Services.ListProviders do
  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.Shared.Cache.Ets.Implementations.ProviderCache
  @key "providers-list"
  def execute() do
    ProviderCache.get(@key)
    |> case do
      {:ok, providers} ->
        IO.inspect("com cache")
        providers

      {:not_found, []} ->
        IO.inspect("sem cache")

        providers = AccountRepository.list_providers()
        ProviderCache.save(@key, providers)
        providers
    end
  end
end
