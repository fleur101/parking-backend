defmodule Parking.Repo.Migrations.PopulateLocations do
  use Ecto.Migration
  alias Parking.Repo
  alias Parking.Sales.Location

  def change do
    locations = [
      %Location{
        parking_space_id: 1,
        is_available: true,
        pricing_zone: "A",
        spot_number: "Parking Spot 1",
      },
      %Location{
        parking_space_id: 1,
        is_available: true,
        pricing_zone: "A",
        spot_number: "Parking Spot 2",
      },
      %Location{
        parking_space_id: 1,
        is_available: true,
        pricing_zone: "A",
        spot_number: "Parking Spot 3",
      },
      %Location{
        parking_space_id: 1,
        is_available: true,
        pricing_zone: "A",
        spot_number: "Parking Spot 4",
      },
      %Location{
        parking_space_id: 1,
        is_available: true,
        pricing_zone: "A",
        spot_number: "Parking Spot 5",
      },
      %Location{
        parking_space_id: 1,
        is_available: true,
        pricing_zone: "A",
        spot_number: "Parking Spot 6",
      },
      %Location{
        parking_space_id: 1,
        is_available: true,
        pricing_zone: "A",
        spot_number: "Parking Spot 7",
      },
      %Location{
        parking_space_id: 1,
        is_available: true,
        pricing_zone: "A",
        spot_number: "Parking Spot 8",
      },
      %Location{
        parking_space_id: 2,
        is_available: true,
        pricing_zone: "A",
        spot_number: "Parking Spot 1",
      },
      %Location{
        parking_space_id: 2,
        is_available: true,
        pricing_zone: "A",
        spot_number: "Parking Spot 2",
      },
      %Location{
        parking_space_id: 2,
        is_available: true,
        pricing_zone: "B",
        spot_number: "Parking Spot 3",
      },
      %Location{
        parking_space_id: 2,
        is_available: true,
        pricing_zone: "B",
        spot_number: "Parking Spot 4",
      }
    ]

    Enum.each(locations, fn location ->
      Repo.insert!(location)
    end)
  end
end
