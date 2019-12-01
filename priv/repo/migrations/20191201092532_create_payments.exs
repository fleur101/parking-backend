defmodule Parking.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :amount, :float
      add :stripe_charge_id, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :booking_id, references(:bookings, on_delete: :nothing)

      timestamps()
    end

    create index(:payments, [:user_id])
    create index(:payments, [:booking_id])
  end
end
