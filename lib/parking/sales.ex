defmodule Parking.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias Parking.Repo

  alias Parking.Sales.Location


  @doc """
  Finds a location.

  """
  def find_parking_spaces(parking_address) do
    %{lat1: lat1, lat2: lat2, lng1: lng1, lng2: lng2} = Parking.Geolocation.find_location(parking_address)
    query = from l in Location,
    where: (l.latitude >= ^lat1 and l.latitude <= ^lat2)
             and (l.longitude >= ^lng1 and l.longitude <= ^lng2)
             and l.is_available == true,
    select: l
    {:ok, Repo.all(query)}
  end
end
