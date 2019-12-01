# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :parking,
  ecto_repos: [Parking.Repo]

# Configures the endpoint
config :parking, ParkingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KBIcvZ7vaCNBARLrO8sBjXOcYKr9W18mdHoTeyGfZswcVD1pE8iJ9wErrJxno9O9",
  render_errors: [view: ParkingWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Parking.PubSub, adapter: Phoenix.PubSub.PG2],
  googlemaps_key: "AIzaSyBzfDmreuvBX8F2V4pijuxoIaeDBmXEEns"


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :parking, Parking.Guardian,
  issuer: "parking",
  secret_key: "0B9VnJ8N2lzx2VYj5hKpAr69bOkBoUwLqC7/VaFD52+6Ewiur+WrfoWzheSzMR88"

config :stripity_stripe, api_key: "sk_test_vyTzpJEDv5OWVSTSBwLFn4N700fsD1tfSx"
config :stripity_stripe, hackney_opts: [{:connect_timeout, 1000}, {:recv_timeout, 5000}]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
