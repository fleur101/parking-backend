defmodule Parking.Repo.Migrations.PopulatePolygonCoordinates do
  use Ecto.Migration
  alias Parking.Sales.{PolygonCoordinates}
  alias Parking.Repo

  def change do
    polygon_coordinates = [
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382186,
        longitude: 26.731285
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382238,
        longitude: 26.731234,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382748,
        longitude: 26.733093,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382911,
        longitude: 26.732948,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.383047,
        longitude: 26.733511,
      },
      %PolygonCoordinates{
        parking_space_id: 1,
        latitude: 58.382826,
        longitude: 26.733892,
      },
      %PolygonCoordinates{
        parking_space_id: 2,
        latitude: 58.382585,
        longitude: 26.730910,
      },
      %PolygonCoordinates{
        parking_space_id: 2,
        latitude: 58.382505,
        longitude: 26.730977,
      },
      %PolygonCoordinates{
        parking_space_id: 2,
        latitude: 58.383171,
        longitude: 26.733375,
      },
      %PolygonCoordinates{
        parking_space_id: 2,
        latitude: 58.383257,
        longitude: 26.733217,
      },
      %PolygonCoordinates{
        parking_space_id: 3,
        latitude: 58.382274,
        longitude: 26.728312,
      },
      %PolygonCoordinates{
        parking_space_id: 3,
        latitude: 58.382391,
        longitude: 26.728374,
      },
      %PolygonCoordinates{
        parking_space_id: 3,
        latitude: 58.382219,
        longitude: 26.728672,
      },
      %PolygonCoordinates{
        parking_space_id: 3,
        latitude: 58.382139,
        longitude:  26.728495,
      },
      %PolygonCoordinates{
        parking_space_id: 4,
        latitude: 58.378148,
        longitude: 26.714115,
      },
      %PolygonCoordinates{
        parking_space_id: 4,
        latitude: 58.378142,
        longitude: 26.714236,
      },
      %PolygonCoordinates{
        parking_space_id: 4,
        latitude: 58.378390,
        longitude: 26.714322,
      },
      %PolygonCoordinates{
        parking_space_id: 4,
        latitude: 58.378404,
        longitude: 26.714201,
      },
      %PolygonCoordinates{
        parking_space_id: 5,
        latitude: 58.378202,
        longitude: 26.713165,
      },
      %PolygonCoordinates{
        parking_space_id: 5,
        latitude: 58.378143,
        longitude: 26.713608,
      },
      %PolygonCoordinates{
        parking_space_id: 5,
        latitude: 58.377969,
        longitude: 26.713522,
      },
      %PolygonCoordinates{
        parking_space_id: 5,
        latitude: 58.378018,
        longitude: 26.713101,
      },
      %PolygonCoordinates{
        parking_space_id: 6,
        latitude: 58.377645,
        longitude: 26.727340,
      },
      %PolygonCoordinates{
        parking_space_id: 6,
        latitude: 58.377960,
        longitude: 26.726718,
      },
      %PolygonCoordinates{
        parking_space_id: 6,
        latitude: 58.378331,
        longitude: 26.727566,
      },
      %PolygonCoordinates{
        parking_space_id: 6,
        latitude: 58.378010,
        longitude: 26.728194,
      },
      %PolygonCoordinates{
        parking_space_id: 7,
        latitude: 58.378092,
        longitude: 26.731150,
      },
      %PolygonCoordinates{
        parking_space_id: 7,
        latitude: 58.377982,
        longitude: 26.731370,
      },
      %PolygonCoordinates{
        parking_space_id: 7,
        latitude: 58.378424,
        longitude: 26.732330,
      },
      %PolygonCoordinates{
        parking_space_id: 7,
        latitude: 58.378541,
        longitude: 26.732102,
      },
      %PolygonCoordinates{
        parking_space_id: 8,
        latitude: 58.376647,
        longitude: 26.728599,
      },
      %PolygonCoordinates{
        parking_space_id: 8,
        latitude: 58.377038,
        longitude: 26.729473,
      },
      %PolygonCoordinates{
        parking_space_id: 8,
        latitude: 58.376897,
        longitude: 26.729811,
      },
      %PolygonCoordinates{
        parking_space_id: 8,
        latitude: 58.376523,
        longitude: 26.728894,
      },

    ]
    Enum.each(polygon_coordinates, fn polygon_coordinate ->
      Repo.insert!(polygon_coordinate)
    end)
  end
end
