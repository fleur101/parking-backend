defmodule ParkingWeb.BookingControllerTest do
  use ParkingWeb.ConnCase
  alias Parking.Repo
  alias Parking.Sales.{Location, Booking, ParkingSpace, PolygonCoordinates}
  alias Parking.Accounts.User
  alias Parking.Guardian
  alias Ecto.Changeset


  @parking_space_params %{
    title: "Raatuse 25",
  }

  @user_attrs %{
    username: "zohaib94",
    email: "zohaibahmedbutt@gmail.com",
    name: "Zohaib Ahmed",
    password: "password"
  }

  @booking_attrs %{
    start_time: "2017-09-28T18:31:32.223Z",
    end_time: "2017-09-28T19:31:32.223Z",
    pricing_type: "hourly"
  }

  @booking_update_attrs %{
    end_time: "2017-09-28T20:31:32.223Z"
  }

  setup %{conn: conn} do
    Repo.delete_all(Booking)
    Repo.delete_all(Location)
    Repo.delete_all(PolygonCoordinates)
    Repo.delete_all(ParkingSpace)
    Repo.delete_all(User)

    parking_space = ParkingSpace.changeset(%ParkingSpace{}, @parking_space_params) |> Repo.insert!()

    location_params = %{
      parking_space_id: parking_space.id,
      is_available: true,
      pricing_zone: "A",
      spot_number: "Parking Spot 1",
    }

    polygon_coordinates = [
      %PolygonCoordinates{
        parking_space_id: parking_space.id,
        latitude: 58.382104,
        longitude: 26.7295357,
      },
    ]

    location = Location.changeset(%Location{}, location_params) |> Repo.insert!()

    Enum.each(polygon_coordinates, fn polygon_coordinate ->
      Repo.insert!(polygon_coordinate)
    end)

    user = User.changeset(%User{}, @user_attrs) |> Repo.insert!()

    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    connection = conn |> put_req_header("accept", "application/json") |> put_req_header("authorization", "bearer: " <> jwt)
    {:ok, conn: connection, location: location, user: user}
  end

  describe "POST /api/v1/bookings" do
    test "Bad Request (No parameters passed)", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), %{})
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "Bad Request (parameters are missing)", %{conn: conn} do
      conn = post(conn, Routes.booking_path(conn, :create), location_id: nil)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "Make a booking", %{conn: conn} do
      user = Repo.one(User)
      location = Repo.all(Location) |> hd
      preloaded_user = Repo.preload(user, [:bookings])

      user_bookings = length(preloaded_user.bookings)

      conn = post(conn, Routes.booking_path(conn, :create), %{
        location_id: to_string(location.id),
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
      location = Repo.all(Location) |> hd

      conn = post(conn, Routes.booking_path(conn, :create), %{
        location_id: to_string(location.id),
        start_time: "2017-09-28T18:31:32.223Z",
        end_time: "2017-09-28T19:31:32.223Z",
        pricing_type: "realtime"
      })

      conn = post(conn, Routes.booking_path(conn, :create), %{
        location_id: to_string(location.id),
        start_time: "2017-09-28T18:31:32.223Z",
        end_time: "2017-09-28T19:31:32.223Z",
        pricing_type: "realtime"
      })

      assert json_response(conn, 422)["errors"] != %{}
    end

  end
end
