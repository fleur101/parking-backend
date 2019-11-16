defmodule ParkingWeb.UserView do
  use ParkingWeb, :view
  alias ParkingWeb.UserView

  def render("show.json", %{user: user, token: token}) do
    %{data: render_one(user, UserView, "user.json"), token: token}
  end

  def render("user.json", %{user: user}) do
    %{name: user.name, username: user.username}
  end
end
