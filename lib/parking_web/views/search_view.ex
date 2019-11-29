defmodule ParkingWeb.SearchView do
  use ParkingWeb, :view
  alias Parking.Sales

  def render("search_results.json", %{locations: locations}) do
    locations
  end
end
