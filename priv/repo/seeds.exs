# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Parking.Repo.insert!(%Parking.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Parking.Sales.Location
alias Parking.Repo

Location.changeset(%Location{}, %{
  latitude: "58.382940",
  longitude: "26.732479",
  pricing_zone: "B",
  is_available: true
}) |> Repo.insert!()
