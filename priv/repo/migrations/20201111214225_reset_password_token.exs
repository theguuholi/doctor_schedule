defmodule DoctorSchedule.Repo.Migrations.ResetPasswordToken do
  use Ecto.Migration

  def change do
    create table(:user_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :token, :uuid, null: false

      add :user_id,
          references(:users, on_delete: :nilify_all, on_update: :nilify_all, type: :uuid)

      timestamps()
    end
  end
end
