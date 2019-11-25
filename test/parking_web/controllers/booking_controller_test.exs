defmodule ParkingWeb.BookingControllerTest do
  use ParkingWeb.ConnCase
  alias Parking.Repo
  alias Parking.Sales.Location
  alias Parking.Accounts.User
  alias Parking.Guardian

  @location1_attrs %{
    latitude: "58.3824278",
    longitude: "26.7291562",
    pricing_zone: "A",
    is_available: true
  }

  @location2_attrs %{
    latitude: "58.382940",
    longitude: "26.732479",
    pricing_zone: "B",
    is_available: true
  }

  @user_attrs %{
    username: "zohaib94",
    email: "zohaibahmedbutt@gmail.com",
    name: "Zohaib Ahmed",
    password: "password"
  }

  setup %{conn: conn} do
    Repo.delete_all(Location)
    Repo.delete_all(User)

    Location.changeset(%Location{}, @location1_attrs) |> Repo.insert!()
    Location.changeset(%Location{}, @location2_attrs) |> Repo.insert!()
    User.changeset(%User{}, @user_attrs) |> Repo.insert!()

    user = Repo.one(User)

    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    connection = conn |> put_req_header("accept", "application/json") |> put_req_header("authorization", "bearer: " <> jwt)
    {:ok, conn: connection}
  end

  describe "POST /api/v1/bookings" do
    test "Bad Request (No parameters passed)", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), %{})
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "Bad Request (parameters are missing)", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), longitude: nil)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "Make a booking", %{conn: conn} do
      user = Repo.one(User)
      preloaded_user = Repo.preload(user, [:bookings])

      user_bookings = length(preloaded_user.bookings)

      conn = post(conn, Routes.booking_path(conn, :create), %{
        latitude: 58.38294,
        longitude: 26.732479,
        start_time: "2017-09-28T18:31:32.223Z",
        end_time: "2017-09-28T19:31:32.223Z",
        pricing_type: "hourly"
      })

      response = json_response(conn, 200)
      preloaded_user = user |> Repo.preload([:bookings], force: true)

      assert response["booked_by"] == user.name
      assert length(preloaded_user.bookings) > user_bookings
    end

    test "No available parking space present", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), %{
        latitude: 59.39439,
        longitude: 24.6690273,
        start_time: "2017-09-28T18:31:32.223Z",
        end_time: "2017-09-28T19:31:32.223Z",
        pricing_type: "hourly"
      })

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
