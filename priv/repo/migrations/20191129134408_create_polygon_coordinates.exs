defmodule Parking.Repo.Migrations.CreatePolygonCoordinates do
  use Ecto.Migration

  def change do
    create table(:polygon_coordinates) do
      add :latitude, :float
      add :longitude, :float
      add :parking_space_id, references(:parking_spaces, on_delete: :nothing)

      timestamps()
    end

    create index(:polygon_coordinates, [:parking_space_id])
  end
end
