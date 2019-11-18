defmodule Parking.Sales.Location do
  use Ecto.Schema
  use Timex

  import Ecto.Changeset

  @hourly_prices %{
    "A" => 2,
    "B" => 1
  }

  @realtime_prices %{
    "A" => 0.16,
    "B" => 0.8
  }

  schema "locations" do
    field :latitude, :float
    field :longitude, :float
    field :pricing_zone, :string
    field :is_available, :boolean
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
end
