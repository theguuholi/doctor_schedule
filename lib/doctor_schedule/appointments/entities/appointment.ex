defmodule DoctorSchedule.Appointments.Entities.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  alias DoctorSchedule.Accounts.Entities.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "appointments" do
    field :date, :naive_datetime
    belongs_to :user, User, foreign_key: :user_id, type: :binary_id
    belongs_to :provider, User, foreign_key: :provider_id, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(appointment, attrs) do
    appointment
    |> cast(attrs, [:date, :user_id, :provider_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:provider_id)
    |> validate_required([:date, :user_id, :provider_id])
  end
end
