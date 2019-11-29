defmodule Parking.Repo.Migrations.AddSpotNumberToLocations do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :spot_number, :string
    end
  end
end
