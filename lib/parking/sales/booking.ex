defmodule Parking.Sales.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  alias Parking.Accounts.User
  alias Parking.Sales.Location
  alias Parking.Sales.Booking
  alias Parking.Sales
  alias Parking.Geolocation
  alias Parking.Repo
  alias Ecto.Multi

  use Timex

  @payment_statuses %{
    pending: "pending"
  }

  schema "bookings" do
    field :end_time, :utc_datetime
    field :payment_status, :string, default: @payment_statuses.pending
    field :pricing_type, :string
    field :start_time, :utc_datetime
    belongs_to :location, Location
    belongs_to :user, User

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

  def format_coordinates(coordinate_string) do
    String.to_float(coordinate_string)
  end

  def format_booking_params(params) do
    Map.merge(params, %{
      latitude: format_coordinates(params["latitude"]),
      longitude: format_coordinates(params["longitude"]),
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
    %{latitude: latitude, longitude: longitude, start_time: start_time, end_time: end_time, pricing_type: pricing_type} = format_booking_params(params)

    nearest_locations = Location.get_nearest_locations(latitude, longitude)

    if length(nearest_locations) > 0 do
      near_spot = Location.sort_by_distances(nearest_locations, longitude, latitude) |> hd

      multi_transaction = Multi.new |> Multi.run(:booking, fn _repo, _changes ->
        case Repo.insert(new_booking_struct(user, near_spot, start_time, end_time, pricing_type)) do
          {:ok, booking} -> Location.make_unavailable(near_spot)
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
      {:error, ["All nearby locations are already booked"]}
    end
  end

end
