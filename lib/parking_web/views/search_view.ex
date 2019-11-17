defmodule ParkingWeb.SearchView do
  use ParkingWeb, :view
  alias Parking.Sales.Location

  def render("search_results.json", %{locations: locations, end_time: end_time}) do
    Location.format_search_response(locations, end_time)
  end
end
