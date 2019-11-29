defmodule Parking.Repo.Migrations.PopulatePolygonCoordinates do
  use Ecto.Migration
  alias Parking.Sales.{PolygonCoordinates}
  alias Parking.Repo

  def change do
    polygon_coordinates = [
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382174,
        longitude: 26.7300827,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.381986,
        longitude: 26.7291977,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382188,
        longitude: 26.7287307,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382402,
        longitude: 26.7281727,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.38279,
        longitude: 26.7289507,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382197,
        longitude: 26.7296747,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382104,
        longitude: 26.7295357,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382104,
        longitude: 26.7295357,
      },
      %PolygonCoordinates{
        parking_space_id: 2,
        latitude: 58.378375,
        longitude: 26.7136298,
      },
      %PolygonCoordinates{
        parking_space_id: 2,
        latitude: 58.378412,
        longitude: 26.7145258,
      },
      %PolygonCoordinates{
        parking_space_id: 2,
        latitude: 58.378515,
        longitude: 26.7144508,
      },
      %PolygonCoordinates{
        parking_space_id: 2,
        latitude: 58.378528,
        longitude: 26.7136948,
      }
    ]

    Enum.each(polygon_coordinates, fn polygon_coordinate ->
      Repo.insert!(polygon_coordinate)
    end)
  end
end
