defmodule ParkingWeb.SearchControllerTest do
  use ParkingWeb.ConnCase
  alias Parking.Repo
  alias Parking.Sales.Location
  alias Parking.Accounts.User
  alias Parking.Guardian

  @location1_attrs %{
    latitude: "58.377361",
    longitude: "26.715302",
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

  describe "interactive search" do
    test "invalid request", %{conn: conn} do
      conn = post(conn, Routes.search_path(conn, :search), %{})
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "search requires a 'parking address'", %{conn: conn} do
      conn = post(conn, Routes.search_path(conn, :search), parking_address: nil)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "returns all available parking spaces in the distance of 250 meters", %{conn: conn} do
      conn = post(conn, Routes.search_path(conn, :search), parking_address: "Raatuse 22")
      assert [%{
          "id" => id,
          "latitude" => 58.382940,
          "longitude" => 26.732479,
          "pricing_zone" => "B",
          "is_available" => true
        }] = json_response(conn, 200)
    end
  end
end
