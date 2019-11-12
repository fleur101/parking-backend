defmodule ParkingWeb.SessionController do
  use ParkingWeb, :controller
  alias Parking.{Authentication, Repo}
  alias Parking.Accounts.User

  action_fallback ParkingWeb.FallbackController

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    user = Repo.get_by(User, username: username)
    case Authentication.check_credentials(user, password) do
      {:ok, _} ->
        conn
        |> Authentication.login(user)
        |> put_status(200)
        |> render("show.json", user: user)

      {:error, _reason} ->
        conn
        |> put_status(401)
        |> send("Authentication failed")
    end
  end


end

