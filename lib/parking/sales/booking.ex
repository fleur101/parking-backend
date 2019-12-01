defmodule Parking.Sales.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  alias Parking.Accounts.User
  alias Parking.Sales
  alias Parking.Sales.{Location, Booking, Payment}
  alias Parking.Repo
  alias Ecto.Multi
  alias Ecto.Changeset

  use Timex

  @payment_statuses %{
    pending: "pending",
    paid: "paid"
  }

  schema "bookings" do
    field :end_time, :utc_datetime
    field :payment_status, :string, default: @payment_statuses.pending
    field :pricing_type, :string
    field :start_time, :utc_datetime
    belongs_to :location, Location
    belongs_to :user, User
    has_many :payments, Payment

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:pricing_type, :payment_status, :start_time, :end_time])
    |> validate_required([:pricing_type, :payment_status, :start_time, :end_time])
  end

  def format_time(time_string) do
    {:ok, start_time, _} = DateTime.from_iso8601(time_string)
    DateTime.truncate(start_time, :second)
  end

  def format_booking_params(params) do
    Map.merge(params, %{
      location_id: String.to_integer(params["location_id"]),
      start_time: format_time(params["start_time"]),
      end_time: format_time(params["start_time"]),
      pricing_type: params["pricing_type"]
    })
  end

  def new_booking_struct(user, nearest_location, start_time, end_time, pricing_type) do
    %Booking{
      user_id: user.id,
      location_id: nearest_location.id,
      start_time: start_time,
      end_time: end_time,
      pricing_type: pricing_type
    }
  end

  def create_booking_for(user, params) do
    %{location_id: location_id, start_time: start_time, end_time: end_time, pricing_type: pricing_type} = format_booking_params(params)

    location = Location.find_by_id(location_id)

    if (location && location.is_available) do
      multi_transaction = Multi.new |> Multi.run(:booking, fn _repo, _changes ->
        case Repo.insert(new_booking_struct(user, location, start_time, end_time, pricing_type)) do
          {:ok, booking} -> Location.make_unavailable(location)
                            {:ok, Repo.preload(booking, [:location, :user])}
          {:error, _} -> {:error, ["Failed to book parking space"]}
        end
      end)

      transaction_result = Repo.transaction(multi_transaction)

      case transaction_result do
        {:ok, _} -> transaction_result
        {:error, _} -> {:error, ["Failed to book parking space"]}
      end
    else
      {:error, ["This location is not available at the moment"]}
    end
  end

  def update_status_to(booking, new_status) do
    Booking.changeset(booking) |> Changeset.put_change(:payment_status, new_status) |> Repo.update
  end

  def payment_statuses do
    @payment_statuses
  end

  def calculate_payment(booking) do
    booking = Repo.preload(booking, [:location])
    start_time = Timex.format!(booking.start_time, "%FT%T%:z", :strftime)
    end_time = Timex.format!(booking.end_time, "%FT%T%:z", :strftime)

    euro_price = case booking.pricing_type do
      "hourly" -> Sales.get_hourly_price_of(booking.location, start_time, end_time)
      "realtime" -> Sales.get_realtime_price_of(booking.location, start_time, end_time)
    end

    euro_price * 100
  end
end
