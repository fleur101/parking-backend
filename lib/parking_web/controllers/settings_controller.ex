defmodule ParkingWeb.SettingsController do
  use ParkingWeb, :controller

  alias Parking.Accounts.User
  alias Parking.Guardian

  action_fallback ParkingWeb.FallbackController

  def toggle_monthly(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    {_, user} = User.toggle_monthly_payments(user)
    conn |> render("toggle_monthly.json", user: user)
  end
end
