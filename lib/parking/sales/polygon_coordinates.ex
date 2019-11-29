defmodule Parking.Sales.PolygonCoordinates do
  use Ecto.Schema
  import Ecto.Changeset
  alias Parking.Sales.ParkingSpace

  schema "polygon_coordinates" do
    field :latitude, :float
    field :longitude, :float
    belongs_to :parking_space, ParkingSpace

    timestamps()
  end

  @doc false
  def changeset(polygon_coordinates, attrs) do
    polygon_coordinates
    |> cast(attrs, [:latitude, :longitude])
    |> validate_required([:latitude, :longitude])
  end
end
