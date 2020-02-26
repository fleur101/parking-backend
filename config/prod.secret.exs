# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

database_url =
  System.get_env("DATABASE_URL") || ""

config :parking, Parking.Repo,
  ssl: true,
  url: database_url,
  username: "postgres",
  password: "postgres",
  database: "parkingx",
  # hostname: "35.193.23.247",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") || "uF+uMsFwk8osD8wXpMAI2cgkv7qzimZk5e7psmiVYC8uTY2xNGaVveYMsivFkQj5"

config :parking, ParkingWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :parking, ParkingWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
