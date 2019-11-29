defmodule Parking.Sales.ParkingSpace do
  use Ecto.Schema
  import Ecto.Changeset
  alias Parking.Sales.PolygonCoordinates
  alias Parking.Sales.Location

  schema "parking_spaces" do
    field :description, :string
    field :title, :string
    has_many :polygon_coordinates, PolygonCoordinates
    has_many :locations, Location

    timestamps()
  end

  @doc false
  def changeset(parking_space, attrs) do
    parking_space
    |> cast(attrs, [:title, :description])
    |> validate_required([:title])
  end
end
