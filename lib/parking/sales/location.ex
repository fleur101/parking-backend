defmodule Parking.Sales.Location do
  use Ecto.Schema
  use Timex

  import Ecto.Changeset
  import Ecto.Query

  alias Parking.Sales.{Booking, Location, ParkingSpace}
  alias Parking.Repo
  alias Parking.Geolocation
  alias Ecto.Changeset

  @hourly_prices %{
    "A" => 2,
    "B" => 1
  }

  @realtime_prices %{
    "A" => 0.16,
    "B" => 0.08
  }

  @range 500.0

  schema "locations" do
    field :pricing_zone, :string
    field :is_available, :boolean
    field :spot_number, :string
    has_many :bookings, Booking
    belongs_to :parking_space, ParkingSpace

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:pricing_zone, :is_available, :parking_space_id, :spot_number])
    |> validate_required([:pricing_zone, :is_available, :spot_number])
  end

  def get_range do
    @range
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

  def find_by_id_query(id) do
    from location in Location,
    where: (location.id == ^id),
    select: location
  end

  def find_by_id(id) do
    Repo.one(find_by_id_query(id))
  end
end
