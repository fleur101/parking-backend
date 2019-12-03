defmodule ParkingWeb.SearchController do
  use ParkingWeb, :controller

  alias Parking.Sales

  action_fallback ParkingWeb.FallbackController


  def search(_conn, %{"parking_address" => nil}) do
    errors = ["parking address can't be blank"]
    {:error, errors}
  end

  def search(conn, %{"parking_address" => parking_address, "end_time" => end_time}) do
    with {:ok, locations} <- Sales.find_parking_spaces(parking_address, end_time) do
    conn
      |> put_status(200)
      |> render("search_results.json", locations: locations, end_time: end_time)
    end
  end

  def search(conn, %{"parking_address" => parking_address}) do
    with {:ok, locations} <- Sales.find_parking_spaces(parking_address, nil) do
    conn
      |> put_status(200)
      |> render("search_results.json", locations: locations, end_time: false)
    end
  end

  def search(conn, %{"longitude" => lng, "lattitude" => lat, "end_time" => end_time}) do
    with {:ok, locations} <- Sales.find_parking_spaces_by_location(lat, lng, end_time) do
      conn
      |> put_status(200)
      |> render("search_results.json", locations: locations, end_time: false)
    end
  end

  def search(conn, %{"longitude" => lng, "lattitude" => lat}) do
    with {:ok, locations} <- Sales.find_parking_spaces_by_location(lat, lng, nil) do
      conn
      |> put_status(200)
      |> render("search_results.json", locations: locations, end_time: false)
    end
  end


  def search(_conn, _) do
    errors = ["invalid request"]
    {:error, errors}
  end

end
