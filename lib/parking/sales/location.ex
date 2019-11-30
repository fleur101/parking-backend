defmodule Parking.Sales.Location do
  use Ecto.Schema
  use Timex

  import Ecto.Changeset

  alias Parking.Sales.Booking
  alias Parking.Sales.Location
  alias Parking.Repo
  alias Parking.Geolocation
  alias Ecto.Changeset
  alias Parking.Sales

  @hourly_prices %{
    "A" => 2,
    "B" => 1
  }

  @realtime_prices %{
    "A" => 0.16,
    "B" => 0.08
  }

  schema "locations" do
    field :latitude, :float
    field :longitude, :float
    field :pricing_zone, :string
    field :is_available, :boolean
    has_many :bookings, Booking
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:longitude, :latitude, :pricing_zone, :is_available])
    |> validate_required([:longitude, :latitude, :pricing_zone])
  end

  def get_hourly_price_by(pricing_zone) do
    @hourly_prices[pricing_zone]
  end

  def get_realtime_price_by(pricing_zone) do
    @realtime_prices[pricing_zone]
  end

  def make_unavailable(location) do
    Location.changeset(location) |> Changeset.put_change(:is_available, false) |> Repo.update
  end

  def sort_by_distances(locations, longitude, latitude) do
    Enum.sort_by(locations, fn (location) -> Geolocation.distance_formula(latitude, location.latitude, longitude, location.longitude) end)
  end

  def get_nearest_locations(latitude, longitude) do
    Sales.find_parking_spaces_by_coordinates(latitude, longitude, 250.0)
  end
end
