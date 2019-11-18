defmodule ParkingWeb.UserController do
  use ParkingWeb, :controller

  alias Parking.Accounts
  alias Parking.Accounts.User
  alias Parking.Guardian

  action_fallback ParkingWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
        {:ok, jwt, _} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(201)
      |> render("show.json", %{user: user, token: jwt})
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
 end

end
