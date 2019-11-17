defmodule ParkingWeb.SearchControllerTest do
  use ParkingWeb.ConnCase
  alias Parking.Repo
  alias Parking.Sales.Location

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

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    Repo.delete_all(Location)
    Location.changeset(%Location{}, @location1_attrs) |> Repo.insert!()
    Location.changeset(%Location{}, @location2_attrs) |> Repo.insert!()
    :ok
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
