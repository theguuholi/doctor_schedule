defmodule DoctorSchedule.Accounts.Entities.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :email, :string, unique: true
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :role, :string, default: "user"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :role, :password, :password_confirmation])
    |> validate_required([
      :email,
      :first_name,
      :last_name,
      :role,
      :password,
      :password_confirmation
    ], message: "can't be blank")
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/, message: "has invalid format please type a valid e-mail")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:password, min: 6, max: 100, message: "password should have between 6 to 100 chars")
    |> validate_confirmation(:password)
  end
end
