defmodule Parking.Geolocation do
  def find_location(address) do
    # uri = "https://api.mapbox.com/geocoding/v5/mapbox.places/#{URI.encode(address)}%&key=#{Application.get_env(:parking, :mapbox_key)}"
    uri = "https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode(address <> " tartu")}&key=#{ParkingWeb.Endpoint.config(:googlemaps_key)}"
    response = HTTPoison.get! uri
    req = Poison.decode!(response.body)
    %{"lat" => lat, "lng" => lng} = hd(req["results"])["geometry"]["location"]
    find_new_coords(lat, lng, 250.0)
  end

  def find_new_coords(lat, lng, distInMeters) do
    meterPerLatDegree = 111320
    latDegreeDist = distInMeters/meterPerLatDegree
    lngDegreeDist = latDegreeDist * :math.cos(lat*:math.pi()/180)
    lat_south = lat - latDegreeDist
    lat_north = lat + latDegreeDist
    lng_east = lng - lngDegreeDist
    lng_west = lng + lngDegreeDist
    %{lat1: lat_south, lat2: lat_north, lng1: lng_east, lng2: lng_west}
  end

  def distance_formula(lat1, lat2, lng1, lng2) do
    latDifference = lat2 - lat1
    lngDifference = lng2 - lng1
    sumOfSquares = :math.pow(latDifference, 2) + :math.pow(lngDifference, 2)

    :math.sqrt(sumOfSquares)
  end

end
