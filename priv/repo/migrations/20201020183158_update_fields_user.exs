defmodule DoctorSchedule.Repo.Migrations.UpdateFieldsUser do
  use Ecto.Migration

  def change do
    alter table(:users, primary_key: false) do
      remove :id
      add :id, :uuid, primary_key: true
    end

    create(unique_index(:users, [:email]))
  end
end
