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

  def get_hourly_price_of(location, start_time, end_time) do
    hourly_cost = @hourly_prices[location.pricing_zone]

    datetime_start = Timex.parse!(start_time, "%FT%T%:z", :strftime)
    datetime_end = Timex.parse!(end_time, "%FT%T%:z", :strftime)
    datetime_diff = DateTime.diff(datetime_end, datetime_start)

    case datetime_diff > 0 do
      false -> 0.0
      _ -> Float.floor(hourly_cost * (Float.ceil(datetime_diff / (60*60))), 2)
    end
  end

  def get_realtime_price_of(location, start_time, end_time) do
    realtime_cost = @realtime_prices[location.pricing_zone]

    datetime_start = Timex.parse!(start_time, "%FT%T%:z", :strftime)
    datetime_end = Timex.parse!(end_time, "%FT%T%:z", :strftime)
    datetime_diff = DateTime.diff(datetime_end, datetime_start)

    case datetime_diff > 0 do
      false -> 0.0
      _ -> Float.floor(realtime_cost * (Float.ceil(datetime_diff / (5*60))), 2)
    end
  end

  def format_search_response(locations, end_time) do
    locations |>
    Enum.map(fn location ->
      location_response = %{
                            id: location.id,
                            latitude: location.latitude,
                            longitude: location.longitude,
                            pricing_zone: location.pricing_zone,
                            is_available: location.is_available
                          }

      if end_time do
        start_time = Timex.format!(Timex.now, "%FT%T%:z", :strftime)

        price_data = %{
          hourly_price: get_hourly_price_of(location, start_time, end_time),
          realtime_price: get_realtime_price_of(location, start_time, end_time)
        }

        Map.merge(location_response, price_data)
      else
        location_response
      end
    end)
  end
end
