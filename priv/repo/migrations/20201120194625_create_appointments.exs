defmodule DoctorSchedule.Repo.Migrations.CreateAppointments do
  use Ecto.Migration

  def change do
    create table(:appointments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :date, :naive_datetime

      add :user_id,
          references(:users, on_delete: :nilify_all, on_update: :nilify_all, type: :uuid)

      add :provider_id,
          references(:users, on_delete: :nilify_all, on_update: :nilify_all, type: :uuid)

      timestamps()
    end

    create index(:appointments, [:user_id])
    create index(:appointments, [:provider_id])
  end
end
