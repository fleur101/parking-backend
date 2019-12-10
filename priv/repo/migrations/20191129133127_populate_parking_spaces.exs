defmodule Parking.Repo.Migrations.PopulateParkingSpaces do
  use Ecto.Migration
  alias Parking.Sales.ParkingSpace
  alias Parking.Repo

  def change do
    parking_space_params = [
      %{
        title: "Raatuse 22 - #1",
      },
      %{
        title: "Raatuse 22 - #2",
      },
      %{
        title: "Narva 25",
      },
      %{
        title: "Liivi 2",
      },
      %{
        title: "Liivi 4",
      },
      %{
        title: "Kaubamaja",
      },
      %{
        title: "Tasku",
      },
      %{
        title: "Kvartal",
      }
    ]

    Enum.each(parking_space_params, fn parking_space_param ->
      ParkingSpace.changeset(%ParkingSpace{}, %{
        title: parking_space_param.title
      }) |> Repo.insert!()
    end)
  end
end
