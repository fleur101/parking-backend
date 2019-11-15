defmodule Parking.Sales.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :latitude, :float
    field :longitude, :float
    field :pricing_zone, :string
    field :is_available, :boolean
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:longitude, :latitude, :pricing_zone, :is_available])
    |> validate_required([:longitude, :latitude, :pricing_zone])
  end

end
