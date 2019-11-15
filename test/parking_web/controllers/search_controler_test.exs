defmodule ParkingWeb.UserControllerTest do
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
    latitude: "58.382311",
    longitude: "26.728385",
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
    test "search requires a 'parking address'" do
      conn = post (conn, Routes.search_path(conn, :search), parking_address: nil)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "returns all available parking spaces in the distance of 250 meters" do

      conn = post (conn, Routes.search_path(conn, :search), parking_address: "Raatuse 22")
      assert json_response(conn, 200) == %{
        "parking_spaces" => [@location2_attrs]
      }
    end
  end
end
