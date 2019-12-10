defmodule ParkingWeb.SearchController do
  use ParkingWeb, :controller

  alias Parking.Sales

  action_fallback ParkingWeb.FallbackController


  def search(_conn, %{"parking_address" => nil}) do
    errors = ["parking address can't be blank"]
    {:error, errors}
  end

  def search(conn, %{"parking_address" => parking_address} = params) do
    end_time = params["end_time"]
    latLng = Parking.Geolocation.find_coordinates(parking_address)
    with {:ok, locations} <- Sales.find_parking_spaces(latLng, end_time) do
    conn
      |> put_status(200)
      |> render("search_results.json", locations: locations, end_time: end_time, search_location: latLng)
    end
  end

  def search(conn, %{"longitude" => lng, "lattitude" => lat} = params) do
    end_time = params["end_time"]
    with {:ok, locations} <- Sales.find_parking_spaces(%{lat: lat, lng: lng}, end_time) do
      conn
      |> put_status(200)
      |> render("search_results.json", locations: locations, end_time: end_time, search_location: %{lat: lat, lng: lng})
    end
  end

  def search(_conn, _) do
    errors = ["invalid request"]
    {:error, errors}
  end

end
