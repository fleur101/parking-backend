defmodule Parking.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias Parking.Repo
  alias Parking.Sales.{Location, Booking, ParkingSpace, PolygonCoordinates, Payment}
  alias Parking.Accounts.User



  @doc """
  Finds a location.

  """
  def parking_spaces_within_coordinates(lat1, lat2, lng1, lng2) do
    from pc in PolygonCoordinates,
    where: (pc.latitude >= ^lat1 and pc.latitude <= ^lat2)
             and (pc.longitude >= ^lng1 and pc.longitude <= ^lng2),
    select: pc.parking_space_id,
    distinct: pc.parking_space_id
  end

  def parking_spaces_in_range(lat1, lat2, lng1, lng2) do
    parking_space_ids = Repo.all(parking_spaces_within_coordinates(lat1, lat2, lng1, lng2))

    parking_space_query = from ps in ParkingSpace,
                          where: (ps.id in ^parking_space_ids),
                          select: ps

    Repo.all(parking_space_query)
  end

  def find_parking_spaces(%{lat: lat, lng: lng}, end_time) do
    %{lat1: lat1, lat2: lat2, lng1: lng1, lng2: lng2} = Parking.Geolocation.find_coordinates_range(lat, lng, Location.get_range())
    {:ok, parking_spaces_in_range(lat1, lat2, lng1, lng2)
    |> format_parking_space_response(end_time)}
  end

  def format_parking_space_response(parking_spaces, end_time) do
    parking_spaces
    |> Enum.map(fn parking_space ->
      %{
        id: parking_space.id,
        title: parking_space.title,
        locations: get_available_locations_for(parking_space, end_time),
        polygon_coordinates: get_polygon_coordinates_for(parking_space)
      }
    end)
    |> Enum.filter(fn parking_space ->
      length(parking_space.locations) > 0
    end)
  end

  def get_polygon_coordinates_for(parking_space) do
    parking_space = Repo.preload(parking_space, [:polygon_coordinates])

    Enum.map(parking_space.polygon_coordinates, fn polygon_coordinate ->
      %{
        lat: polygon_coordinate.latitude,
        lng: polygon_coordinate.longitude
      }
    end)
  end

  def get_available_locations_for(parking_space, end_time) do
    parking_space = Repo.preload(parking_space, [:locations])

    available_locations = Enum.filter(parking_space.locations, fn location ->
      location.is_available == true
    end)

    format_location_response(available_locations, end_time)
  end

  def get_hourly_price_of(location, start_time, end_time) do
    hourly_cost = Location.get_hourly_price_by(location.pricing_zone)

    datetime_start = Timex.parse!(start_time, "%FT%T%:z", :strftime)
    datetime_end = Timex.parse!(end_time, "%FT%T%:z", :strftime)
    datetime_diff = DateTime.diff(datetime_end, datetime_start)

    case datetime_diff > 0 do
      false -> 0.0
      _ -> Float.round(hourly_cost * (Float.ceil(datetime_diff / (60*60))), 2)
    end
  end

  def get_realtime_price_of(location, start_time, end_time) do
    realtime_cost = Location.get_realtime_price_by(location.pricing_zone)

    datetime_start = Timex.parse!(start_time, "%FT%T%:z", :strftime)
    datetime_end = Timex.parse!(end_time, "%FT%T%:z", :strftime)
    datetime_diff = DateTime.diff(datetime_end, datetime_start)

    case datetime_diff > 0 do
      false -> 0.0
      _ -> Float.round(realtime_cost * (Float.ceil(datetime_diff / (5*60))), 2)
    end
  end

  def format_location_response(locations, end_time) do
    locations |>
    Enum.map(fn location ->
      location_response = %{
                            id: location.id,
                            pricing_zone: location.pricing_zone,
                            hourly_price: Location.get_hourly_price_by(location.pricing_zone),
                            realtime_price: Location.get_realtime_price_by(location.pricing_zone),
                            is_available: location.is_available,
                            spot_number: location.spot_number
                          }

      if end_time do
        start_time = Timex.format!(Timex.now, "%FT%T%:z", :strftime)

        estimated_price_data = %{
          estimated_hourly_price: get_hourly_price_of(location, start_time, end_time),
          estimated_realtime_price: get_realtime_price_of(location, start_time, end_time)
        }

        Map.merge(location_response, estimated_price_data)
      else
        location_response
      end
    end)
  end


  def update_location_statuses() do
    thresholdTime = Timex.now |> Timex.add(Timex.Duration.from_minutes(2))
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

  def find_extend_candidates() do
    thresholdTimeUpper = Timex.now |> Timex.add(Timex.Duration.from_minutes(10))
    thresholdTimeLower = Timex.shift(thresholdTimeUpper, seconds: -10)
    results =
            from(b in Booking,
                where: b.pricing_type == "hourly" and b.end_time <= ^thresholdTimeUpper and b.end_time > ^thresholdTimeLower,
                select: %{id: b.user_id, booking_id: b.id})
            |> Repo.all()
    results
  end

  def extend_parking_time(booking_id, end_time) do
    booking = Repo.get!(Booking, booking_id)
    changeset = Booking.changeset(booking, %{end_time: end_time})
    Repo.update(changeset)
  end

  def get_monthly_subscriber_bookings(date) do
    query = from b in Booking,
            join: u in User,
            on: b.user_id == u.id,
            where: u.monthly_paying == true
                   and b.payment_status == "paid"
                   and b.pricing_type == "realtime"
                   and b.end_time <= ^date

    bookings = Repo.all(query)

    Enum.filter(bookings, fn booking ->
      booking_payments = Repo.preload(booking, [:payments])
      payments = booking_payments.payments
      length(payments) == 0
    end)
  end

  def get_realtime_bookings() do
    query = from b in Booking,
            join: u in User,
            on: b.user_id == u.id,
            where: u.monthly_paying == false
                   and b.payment_status == "paid"
                   and b.pricing_type == "realtime"
                   and b.end_time <= ^Timex.now

    bookings = Repo.all(query)

    Enum.filter(bookings, fn booking ->
      booking_payments = Repo.preload(booking, [:payments])
      payments = booking_payments.payments
      length(payments) == 0
    end)
  end

  def charge_realtime_on_month() do
    charge_monthly_on(Timex.today)
  end

  def charge_realtime_on_end() do
    charge_realtime()
  end

  def charge_realtime() do
    pay_for(get_realtime_bookings())
  end

  def pay_for(bookings) do
    Enum.each(bookings, fn booking ->
      booking = Repo.preload(booking, [:user])

      params = %{
        "stripe_token" => User.test_stripe_token,
        "booking_id" => booking.id
      }

      payment = Payment.create_payment_for(booking.user, params)
      payment
    end)
  end

  def charge_monthly_on(date) do
    today_date = String.split(Date.to_string(date), "-") |> Enum.reverse |> hd
    today_datetime = Timex.parse!(Date.to_string(date), "%Y-%m-%d", :strftime)

    if today_date == "01" do
      pay_for(get_monthly_subscriber_bookings(today_datetime))
    else
      false
    end
  end

  def create_payment_extend(user, params) do
    booking = Repo.get!(Booking, (params["booking_id"]))
    preload_booking = Repo.preload(booking, [:location])

    end_time = Timex.format!(booking.end_time, "%FT%T%:z", :strftime)
    new_end_time = Timex.format!(Booking.format_time(params["end_time"]), "%FT%T%:z", :strftime)
    payment = get_hourly_price_of(preload_booking.location, end_time, new_end_time)*100

    with {:ok, payment} = User.make_payment_extend(%{ source: params["stripe_token"], amount: payment, booking: booking, user: user}) do
      extend_parking_time(booking.id, new_end_time)
      {:ok, payment}
    end
  end

  def view_bookings(user) do
    preload_user = Repo.preload(user, [:bookings])
    {:ok, preload_user.bookings |> Enum.map(fn booking -> Repo.preload(booking, [:location]) end)}
  end
end
