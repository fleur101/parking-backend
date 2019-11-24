defmodule Parking.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :pricing_type, :string
      add :payment_status, :string
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :location_id, references(:locations, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:bookings, [:location_id])
    create index(:bookings, [:user_id])
  end
end
