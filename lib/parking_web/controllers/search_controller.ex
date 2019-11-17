defmodule ParkingWeb.SearchController do
  use ParkingWeb, :controller

  alias Parking.Sales

  action_fallback ParkingWeb.FallbackController


  def search(_conn, %{"parking_address" => nil}) do
    errors = ["parking address can't be blank"]
    {:error, errors}
  end

  def search(conn, %{"parking_address" => parking_address}) do
    with {:ok, locations} <- Sales.find_parking_spaces(parking_address) do
    conn
      |> put_status(200)
      |> render("search_results.json", locations: locations)
    end
  end

  def search(_conn, _) do
    errors = ["invalid request"]
    {:error, errors}
  end

end