defmodule Parking.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Parking.Sales.Booking

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    has_many :bookings, Booking
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :username, :password])
    |> validate_required([:name, :username, :password])
    |> unique_constraint(:username)
    |> validate_length(:password, min: 8)
    |> hash_password
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
