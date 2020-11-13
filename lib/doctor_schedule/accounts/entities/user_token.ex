defmodule DoctorSchedule.Accounts.Entities.UserToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias DoctorSchedule.Accounts.Entities.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "user_tokens" do
    field :token, Ecto.UUID, autogenerate: true
    belongs_to :user, User, foreign_key: :user_id, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(user_token, attrs \\ %{}) do
    user_token
    |> cast(attrs, [:token, :user_id])
    |> validate_required([
      :user_id
    ])
  end
end
