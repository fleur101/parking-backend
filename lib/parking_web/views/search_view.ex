defmodule ParkingWeb.SearchView do
  use ParkingWeb, :view

  def render("search_results.json", %{locations: locations}) do
    locations
    |> Enum.map(fn l -> %{id: l.id, latitude: l.latitude, longitude: l.longitude, pricing_zone: l.pricing_zone, is_available: l.is_available} end)
  end
end
