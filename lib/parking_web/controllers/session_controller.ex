defmodule ParkingWeb.SessionController do
  use ParkingWeb, :controller
  alias Parking.{Authentication, Repo}
  alias Parking.Accounts.User

  action_fallback ParkingWeb.FallbackController

  def create(conn, %{"user" => %{"username" => username, "password" => password}})
  when username != nil and password != nil do
    user = Repo.get_by(User, username: username)
    with {:ok, _} <- Authentication.check_credentials(user, password) do
      conn
      |> Authentication.login(user)
      |> put_status(200)
      |> put_view(ParkingWeb.UserView)
      |> render("show.json", user: user)
    end
  end
  def create(_conn, %{"user" => params}) do
    errors = ["username", "password"]
    |> Enum.filter((fn x -> not Map.has_key?(params, x) end))
    |> Enum.map((fn x -> x <> " can't be blank" end))
    {:error, errors}
  end
end

