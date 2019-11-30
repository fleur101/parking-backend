defmodule Parking.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Parking.Sales.Booking
  alias Parking.Accounts.User
  alias Ecto.Changeset
  import Stripe.Customer
  alias Parking.Repo

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :customer_id, :string
    field :email, :string
    has_many :bookings, Booking
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :username, :password, :customer_id, :email])
    |> validate_required([:name, :username, :password, :email])
    |> unique_constraint(:username)
    |> validate_length(:password, min: 8)
    |> hash_password
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset

  def get_customer_id_for(user) do
    if user.customer_id do
      {:ok, user.customer_id}
    else
      case Stripe.Customer.create(%{email: user.email}) do
        {:error, response} -> {:error, response}
        {:ok, response} -> {:ok, user} = user |> Changeset.change(%{customer_id: response.id}) |> Repo.update
                           {:ok, user.customer_id}
      end
    end
  end
end
