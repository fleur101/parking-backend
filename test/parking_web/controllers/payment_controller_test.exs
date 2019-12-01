defmodule ParkingWeb.PaymentControllerTest do
  use ParkingWeb.ConnCase
  alias Parking.Repo
  alias Parking.Sales.Location
  alias Parking.Accounts.User
  alias Parking.Guardian
  alias Parking.Sales.Booking
  alias Parking.Sales.ParkingSpace

  @parking_space_params %{
    title: "Raatuse 25",
  }

  @user_attrs %{
    username: "zohaib94",
    email: "zohaibahmedbutt@gmail.com",
    name: "Zohaib Ahmed",
    password: "password"
  }

  setup %{conn: conn} do
    Repo.delete_all(Booking)
    Repo.delete_all(Location)
    Repo.delete_all(User)

    parking_space = ParkingSpace.changeset(%ParkingSpace{}, @parking_space_params) |> Repo.insert!()

    location_params = %{
      parking_space_id: parking_space.id,
      is_available: true,
      pricing_zone: "A",
      spot_number: "Parking Spot 1",
    }

    Location.changeset(%Location{}, location_params) |> Repo.insert!()
    User.changeset(%User{}, @user_attrs) |> Repo.insert!()

    location = Repo.one(Location)
    user = Repo.one(User)

    booking_attrs = %Booking{
      location_id: location.id,
      user_id: user.id,
      payment_status: "pending",
      start_time: Booking.format_time("2017-09-28T18:31:32.223Z"),
      end_time: Booking.format_time("2017-09-28T19:31:32.223Z"),
      pricing_type: "hourly"
    }

    booking = Repo.insert(booking_attrs)

    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    connection = conn |> put_req_header("accept", "application/json") |> put_req_header("authorization", "bearer: " <> jwt)
    {:ok, conn: connection}
  end

  describe "POST /api/v1/payments" do
    test "Bad Request (No parameters passed)", %{conn: conn} do
      conn = post(conn, Routes.payment_path(conn, :create), %{})
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "Bad Request (parameters are missing)", %{conn: conn} do
      conn = post(conn, Routes.payment_path(conn, :create), stripe_token: nil)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "Make a booking", %{conn: conn} do
      amount = 2.0
      booking = Repo.all(Booking) |> hd
      booking_status = booking.payment_status

      conn = post(conn, Routes.payment_path(conn, :create), %{
        booking_id: Integer.to_string(booking.id),
        stripe_token: User.test_stripe_token,
      })

      response = json_response(conn, 200)

      booking = Repo.all(Booking) |> hd
      new_booking_status = booking.payment_status

      assert response["amount"] == amount
      assert (new_booking_status == "paid" && new_booking_status != booking_status)
    end
  end
end
