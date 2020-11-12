defmodule DoctorSchedule.Accounts.Repositories.TokenRepositoryTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.Accounts.Repositories.TokenRepository

    alias DoctorSchedule.UserFixture



    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(UserFixture.valid_user())
        |> AccountRepository.create_user()

      user
    end

    test "get_by_token/1 should retrie a token" do
      user = user_fixture()
      {:ok, token, _user} = TokenRepository.generate(user.email)
      assert token == TokenRepository.get_by_token(token).token
    end

    test "generate/1 should create a token" do
      user = user_fixture()
      {:ok, _token, token_user} = TokenRepository.generate(user.email)
      assert user.first_name == token_user.first_name
    end

    test "generate/1 should not create a token with unexistent user" do
      assert {:error, "User does not exists"} == TokenRepository.generate("lfdaslkfjkas;df")
    end

end
