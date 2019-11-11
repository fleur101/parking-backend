use Mix.Config

# Configure your database
config :parking, Parking.Repo,
  username: "postgres",
  password: "postgres",
  database: "parking_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :parking, ParkingWeb.Endpoint,
  http: [port: 4002],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn
config :hound, driver: "chrome_driver"
config :parking, sql_sandbox: true
