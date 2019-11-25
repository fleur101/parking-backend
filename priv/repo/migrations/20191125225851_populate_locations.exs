defmodule Parking.Repo.Migrations.PopulateLocations do
  use Ecto.Migration
  alias Parking.Sales.Location
  alias Parking.Repo

  def change do
    coordinates = [
      {"58.3782485", "26.7124846"},
      {"58.378175", "26.7113043"},
      {"58.38269", "26.7262123"},
      {"58.38269", "26.7262123"},
      {"58.378937", "26.714725"}
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
