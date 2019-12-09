defmodule ParkingWeb.RealtimePaymentsTest do
  use ExUnit.Case

  alias Parking.Repo
  alias Parking.Sales
  alias Parking.Sales.Payment
  alias Parking.Accounts.User
  alias Parking.Sales.Booking
  alias Parking.Sales.ParkingSpace
  alias Parking.Sales.Location
  alias Parking.Sales.PolygonCoordinates

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end


  def setup_test_environment(monthly_paying) do
    Repo.delete_all(Payment)
    Repo.delete_all(Booking)
    Repo.delete_all(Location)
    Repo.delete_all(PolygonCoordinates)
    Repo.delete_all(ParkingSpace)
    Repo.delete_all(User)

    User.changeset(%User{}, %{
      username: "zohaib94",
      email: "zohaibahmedbutt@gmail.com",
      name: "Zohaib Ahmed",
      password: "password",
      monthly_paying: monthly_paying
    }) |> Repo.insert!()

    user = Repo.one(User)

    parking_space = ParkingSpace.changeset(%ParkingSpace{}, %{
      title: "Raatuse 25",
    }) |> Repo.insert!()

    Location.changeset(%Location{}, %{
      parking_space_id: parking_space.id,
      is_available: true,
      pricing_zone: "A",
      spot_number: "Parking Spot 1",
    }) |> Repo.insert!()

    location = Repo.one(Location)

    Booking.changeset(%Booking{}, %{
      user_id: user.id,
      location_id: location.id,
      start_time: "2017-09-28T18:31:32.223Z",
      end_time: "2017-09-28T19:31:32.223Z",
      pricing_type: "realtime",
      payment_status: "paid"
    }) |> Repo.insert!()

    booking = Repo.one(Booking)
  end

  describe "Real Time Payment" do
    test "payment at end time" do
      payment_count = Repo.all(Payment) |> length

      setup_test_environment(false)
      Sales.charge_realtime_on_end()
      new_payment_count = Repo.all(Payment) |> length

      assert (new_payment_count > payment_count)
    end

    test "do not pay for those bookings that have not ended in realtime booking" do
      payment_count = Repo.all(Payment) |> length

      setup_test_environment(true)
      date = ~D[2017-01-01]
      Sales.charge_monthly_on(date)
      new_payment_count = Repo.all(Payment) |> length

      assert (new_payment_count == payment_count)
    end

    test "pay only on first of month for monthly user bookings" do
      payment_count = Repo.all(Payment) |> length

      setup_test_environment(true)
      date = ~D[2017-12-02]
      Sales.charge_monthly_on(date)
      new_payment_count = Repo.all(Payment) |> length

      assert (new_payment_count == payment_count)
    end

    test "pay for only those bookings that have ended in realtime booking" do
      payment_count = Repo.all(Payment) |> length

      setup_test_environment(true)
      date = ~D[2019-12-01]
      Sales.charge_monthly_on(date)
      new_payment_count = Repo.all(Payment) |> length

      assert (new_payment_count > payment_count)
    end
  end
 end
