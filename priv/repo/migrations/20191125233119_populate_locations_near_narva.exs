defmodule Parking.Repo.Migrations.PopulateLocationsNearNarva do
  use Ecto.Migration
  alias Parking.Sales.Location
  alias Parking.Repo

  def change do
    coordinates = [
      {58.383117, 26.727704},
      {58.383100, 26.727811}
    ]

    Enum.each(coordinates, fn coordinate ->
      Location.changeset(%Location{}, %{
        latitude: elem(coordinate, 0),
        longitude: elem(coordinate, 1),
        pricing_zone: "B",
        is_available: true
      }) |> Repo.insert!()
    end)
  end
end
