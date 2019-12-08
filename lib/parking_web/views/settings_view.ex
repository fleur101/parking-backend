defmodule ParkingWeb.SettingsView do
  use ParkingWeb, :view

  def render("toggle_monthly.json", %{user: user}) do
    %{id: user.id, name: user.name, username: user.username, monthly_paying: user.monthly_paying}
  end
end
