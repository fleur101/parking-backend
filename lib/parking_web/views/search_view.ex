defmodule ParkingWeb.SearchView do
  use ParkingWeb, :view

  def render("search_results.json", %{locations: locations, end_time: end_time, search_location: search_location}) do
    %{locations: locations, end_time: end_time, search_location: search_location}
  end
end
