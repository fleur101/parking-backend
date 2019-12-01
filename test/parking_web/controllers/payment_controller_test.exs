defmodule ParkingWeb.PaymentControllerTest do
  use ParkingWeb.ConnCase
  alias Parking.Repo
  alias Parking.Sales.Location
  alias Parking.Accounts.User
  alias Parking.Guardian
  alias Parking.Sales.Booking

  @location1_attrs %{
    latitude: "58.3824278",
    longitude: "26.7291562",
    pricing_zone: "A",
    is_available: true
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

    Location.changeset(%Location{}, @location1_attrs) |> Repo.insert!()
    User.changeset(%User{}, @user_attrs) |> Repo.insert!()

    location = Repo.one(Location)
    user = Repo.one(User)

    booking_attrs = %{
      location_id: location.id,
      user_id: user.id,
      payment_status: "pending",
      start_time: Booking.format_time("2017-09-28T18:31:32.223Z"),
      end_time: Booking.format_time("2017-09-28T19:31:32.223Z"),
      pricing_type: "hourly"
    }

    Booking.changeset(%Booking{}, booking_attrs) |> Repo.insert!()

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
      amount = 3.0
      booking = Repo.all(Booking) |> hd
      booking_status = booking.payment_status

      conn = post(conn, Routes.payment_path(conn, :create), %{
        booking_id: Integer.to_string(booking.id),
        stripe_token: User.test_stripe_token,
        amount: Float.to_string(amount)
      })

      response = json_response(conn, 200)

      booking = Repo.all(Booking) |> hd
      new_booking_status = booking.payment_status

      assert response["amount"] == amount
      assert (new_booking_status == "paid" && new_booking_status != booking_status)
    end
  end
end
