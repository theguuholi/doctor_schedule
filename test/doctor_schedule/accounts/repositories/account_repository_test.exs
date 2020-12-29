defmodule DoctorSchedule.Accounts.Repositories.AccountRepositoryTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Accounts.Repositories.AccountRepository

  describe "users" do
    alias DoctorSchedule.Accounts.Entities.User

    alias DoctorSchedule.UserFixture

    test "list_users/0 returns all users" do
      UserFixture.create_user()
      assert AccountRepository.list_users() |> Enum.count() == 1
    end

    test "list_providers/0 returns all providers" do
      assert AccountRepository.list_providers() |> Enum.count() == 0
    end

    test "get_user!/1 returns the user with given id" do
      user = UserFixture.create_user()

      assert AccountRepository.get_user!(user.id).email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = AccountRepository.create_user(UserFixture.valid_user())
      assert user.email == "test@test"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      response = AccountRepository.create_user(UserFixture.invalid_user())
      assert {:error, %Ecto.Changeset{}} = response
      {:error, changeset} = response
      assert "can't be blank" in errors_on(changeset).email
      assert %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "update_user/2 with valid data updates the user" do
      user = UserFixture.create_user()

      assert {:ok, %User{} = user} =
               AccountRepository.update_user(user, UserFixture.update_user())

      assert user.email == "some@updatedemail"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = UserFixture.create_user()

      assert {:error, %Ecto.Changeset{}} =
               AccountRepository.update_user(user, UserFixture.invalid_user())

      assert user.email == AccountRepository.get_user!(user.id).email
    end

    test "delete_user/1 deletes the user" do
      user = UserFixture.create_user()

      assert {:ok, %User{}} = AccountRepository.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> AccountRepository.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = UserFixture.create_user()

      assert %Ecto.Changeset{} = AccountRepository.change_user(user)
    end
  end
end
