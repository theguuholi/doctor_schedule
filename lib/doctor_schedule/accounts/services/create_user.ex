defmodule DoctorSchedule.Accounts.Services.CreateUser do
  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.Shared.Cache.Ets.Implementations.ProviderCache
  @key "providers-list"

  def execute(user) do
    cond do
      user["role"] == "admin" ->
        create_user_cache(user)

      true ->
        AccountRepository.create_user(user)
    end
  end

  defp create_user_cache(user) do
    AccountRepository.create_user(user)
    |> case do
      {:ok, user} ->
        ProviderCache.get(@key)
        |> case do
          {:ok, _users} ->
            ProviderCache.save(@key, AccountRepository.list_providers())

            {:ok, user}

          {:not_found, _} ->
            ProviderCache.save(@key, AccountRepository.list_providers())
            {:ok, user}
        end

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
