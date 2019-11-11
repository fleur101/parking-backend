defmodule ParkingWeb.UserController do
  use ParkingWeb, :controller

  alias Parking.Accounts
  alias Parking.Accounts.User

  action_fallback ParkingWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(201)
      |> render("show.json", user: user)
    end
  end
end
