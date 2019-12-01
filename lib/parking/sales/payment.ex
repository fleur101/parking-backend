defmodule Parking.Sales.Payment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Parking.Sales.Payment
  alias Parking.Repo
  alias Parking.Accounts.User
  alias Parking.Sales.Booking

  schema "payments" do
    field :amount, :float
    field :stripe_charge_id, :string
    belongs_to :user, Parking.Accounts.User
    belongs_to :booking, Parking.Sales.Booking

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :stripe_charge_id, :user_id, :booking_id])
    |> validate_required([:amount])
  end

  def create_from(params) do
    Payment.changeset(%Payment{}, params) |> Repo.insert!()
  end

  def format_params(user, params) do
    booking = Repo.get(Booking, String.to_integer(params["booking_id"]))
    payment = Booking.calculate_payment(booking)

    %{
      source: params["stripe_token"],
      amount: payment,
      booking: Repo.get(Booking, String.to_integer(params["booking_id"])),
      user: user
    }
  end

  def create_payment_for(user, params) do
    format_params(user, params) |> User.make_payment
  end
end
