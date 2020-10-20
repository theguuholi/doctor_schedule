defmodule DoctorSchedule.Accounts.Entities.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :role, :password_hash])
    |> validate_required([:email, :first_name, :last_name, :role, :password_hash])
  end
end
