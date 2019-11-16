defmodule Parking.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :latitude, :float
      add :longitude, :float
      add :pricing_zone, :string
      add :is_available, :boolean
      timestamps()
    end
  end
end
