defmodule ParkingWeb.SearchControllerTest do
  use ParkingWeb.ConnCase
  alias Parking.Repo
  alias Parking.Sales.{Location, ParkingSpace, PolygonCoordinates}
  alias Parking.Accounts.User
  alias Parking.Guardian
  use Timex

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
    Repo.delete_all(PolygonCoordinates)
    Repo.delete_all(Location)
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

    Location.changeset(%Location{}, location_params) |> Repo.insert!()
    Enum.each(polygon_coordinates, fn polygon_coordinate ->
      Repo.insert!(polygon_coordinate)
    end)
    User.changeset(%User{}, @user_attrs) |> Repo.insert!()

    user = Repo.one(User)

    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    connection = conn |> put_req_header("accept", "application/json") |> put_req_header("authorization", "bearer: " <> jwt)

    {:ok, conn: connection}
  end

  describe "interactive search" do
    test "invalid request", %{conn: conn} do
      conn = post(conn, Routes.search_path(conn, :search), %{})
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "search requires a 'parking address'", %{conn: conn} do
      conn = post(conn, Routes.search_path(conn, :search), parking_address: nil)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "returns all available parking spaces in the distance of 1000 meters", %{conn: conn} do
      conn = post(conn, Routes.search_path(conn, :search), parking_address: "Raatuse 22")
      assert ([
        %{
          "locations" => [
            %{
              "is_available" => true,
              "pricing_zone" => "A",
              "spot_number" => "Parking Spot 1"
            }
          ],
          "polygon_coordinates" => [
            %{"latitude" => 58.382104, "longitude" => 26.7295357}
          ],
          "title" => "Raatuse 25"
        }
      ] = json_response(conn, 200))
    end

    test "searches nearby places alongwith price estimations", %{conn: conn} do
      current_time = Timex.now
      time_after_hour = Timex.shift(current_time, hours: 1)
      end_time = Timex.format!(time_after_hour, "%FT%T%:z", :strftime)

      conn = post(conn, Routes.search_path(conn, :search), parking_address: "Raatuse 22", end_time: end_time)
      assert [
        %{
          "locations" => [
            %{
              "hourly_price" => 2.0,
              "is_available" => true,
              "pricing_zone" => "A",
              "realtime_price" => 1.92,
              "spot_number" => "Parking Spot 1"
            }
          ],
          "polygon_coordinates" => [
            %{"latitude" => 58.382104, "longitude" => 26.7295357}
          ],
          "title" => "Raatuse 25"
        }
      ] = json_response(conn, 200)
    end
  end
end
