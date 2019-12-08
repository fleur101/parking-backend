defmodule Parking.Repo.Migrations.AddMonthlyPayingToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :monthly_paying, :boolean, default: false
    end
  end
end
