defmodule ParkingWeb.SearchView do
  use ParkingWeb, :view
  alias Parking.Sales

  def render("search_results.json", %{locations: locations, end_time: end_time}) do
    Sales.format_search_response(locations, end_time)
  end
end
