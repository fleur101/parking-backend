defmodule Parking.Repo.Migrations.CreateParkingSpaces do
  use Ecto.Migration

  def change do
    create table(:parking_spaces) do
      add :title, :string
      add :description, :string

      timestamps()
    end

  end
end
