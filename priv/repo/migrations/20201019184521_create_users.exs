defmodule DoctorSchedule.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :role, :string
      add :password_hash, :string

      timestamps()
    end
  end
end
