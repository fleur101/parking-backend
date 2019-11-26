defmodule Parking.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias Parking.Repo

  alias Parking.Sales.Location
  alias Parking.Sales.Booking


  @doc """
  Finds a location.

  """
  def find_location_within_coordinates(lat1, lat2, lng1, lng2) do
    from l in Location,
    where: (l.latitude >= ^lat1 and l.latitude <= ^lat2)
             and (l.longitude >= ^lng1 and l.longitude <= ^lng2)
             and l.is_available == true,
    select: l
  end

  def find_parking_spaces(parking_address) do
    %{lat1: lat1, lat2: lat2, lng1: lng1, lng2: lng2} = Parking.Geolocation.find_location(parking_address)
    query = find_location_within_coordinates(lat1, lat2, lng1, lng2)
    {:ok, Repo.all(query)}
  end

  def find_parking_spaces_by_coordinates(latitude, longitude, offset) do
    %{lat1: lat1, lat2: lat2, lng1: lng1, lng2: lng2} = Parking.Geolocation.find_new_coords(latitude, longitude, offset)
    query = find_location_within_coordinates(lat1, lat2, lng1, lng2)
    Repo.all(query)
  end

  def get_hourly_price_of(location, start_time, end_time) do
    hourly_cost = Location.get_hourly_price_by(location.pricing_zone)

    datetime_start = Timex.parse!(start_time, "%FT%T%:z", :strftime)
    datetime_end = Timex.parse!(end_time, "%FT%T%:z", :strftime)
    datetime_diff = DateTime.diff(datetime_end, datetime_start)

    case datetime_diff > 0 do
      false -> 0.0
      _ -> Float.floor(hourly_cost * (Float.ceil(datetime_diff / (60*60))), 2)
    end
  end

  def get_realtime_price_of(location, start_time, end_time) do
    realtime_cost = Location.get_realtime_price_by(location.pricing_zone)

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

  def update_location_statuses() do
    thresholdTime = Timex.now |> Timex.subtract(Timex.Duration.from_minutes(2)) |> Timex.to_naive_datetime()
    results =
            from(l in Location,
                join: b in Booking,
                on: b.location_id == l.id,
                where: b.pricing_type == "hourly",
                group_by: b.location_id,
                having: max(b.end_time) <= ^thresholdTime,
                select: b.location_id)
            |> Repo.all()
    from(l in Location, where: l.id in ^results)
    |> Repo.update_all([set: [is_available: true]])
  end

end
