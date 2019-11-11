defmodule ParkingWeb.UserView do
  use ParkingWeb, :view
  alias ParkingWeb.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, password: user.password, username: user.username}
  end
end
