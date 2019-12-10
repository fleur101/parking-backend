defmodule Parking.Repo.Migrations.AddParkingSpaceIdToLocations do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :parking_space_id, references(:parking_spaces, on_delete: :nothing)
    end
  end
end
