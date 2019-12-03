defmodule ParkingWeb.SearchView do
  use ParkingWeb, :view

  def render("search_results.json", %{locations: locations}) do
    locations
  end
end
