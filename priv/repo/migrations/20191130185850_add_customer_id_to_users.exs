defmodule Parking.Repo.Migrations.AddCustomerIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :customer_id, :string
    end
  end
end
