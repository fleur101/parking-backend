defmodule Parking.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Parking.Sales.Booking
  alias Ecto.Changeset
  alias Parking.Sales.Payment
  alias Parking.Repo
  alias Ecto.Multi

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :customer_id, :string
    field :email, :string
    has_many :bookings, Booking
    has_many :payments, Payment

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :username, :password, :customer_id, :email])
    |> validate_required([:name, :username, :password])
    |> unique_constraint(:username)
    |> validate_length(:password, min: 8)
    |> hash_password
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset

  def get_customer_id_for(user) do
    if (user.customer_id && String.length(user.customer_id) > 0) do
      {:ok, user.customer_id}
    else
      case Stripe.Customer.create(%{email: user.email}) do
        {:error, response} -> {:error, response}
        {:ok, response} -> {:ok, user} = user |> Changeset.change(%{customer_id: response.id}) |> Repo.update
                           {:ok, user.customer_id}
      end
    end
  end

  def make_payment(params) do
    {code, charge} = Stripe.Charge.create(%{
      amount: ceil(params.amount),
      currency: "EUR",
      source: params.source
    })

    case code do
      :ok -> Multi.new |> Multi.run(:payment, fn _repo, _changes ->
              payment = Payment.create_from(%{amount: (params.amount/100), booking_id: params.booking.id, user_id: params.user.id, stripe_charge_id: charge.id})
              Booking.update_status_to(params.booking, Booking.payment_statuses.paid)
              {:ok, payment}
          end) |> Repo.transaction
      _ -> {:error, ["Failed to make payment"]}
    end
  end

  def test_stripe_token do
    {code, sourceToken} = Stripe.Token.create(%{
      card: %{
        exp_month: 10,
        exp_year: 2020,
        number: 4242424242424242,
        cvc: 111
      }
    })

    case code do
      :ok -> sourceToken.id
      _ -> nil
    end
  end
end
