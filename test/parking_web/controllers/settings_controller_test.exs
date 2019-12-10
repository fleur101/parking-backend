defmodule ParkingWeb.SettingsControllerTest do
  use ParkingWeb.ConnCase
  alias Parking.Repo
  alias Parking.Sales.{Location, Booking}
  alias Parking.Accounts.User
  alias Parking.Guardian

  @user_attrs %{
    username: "zohaib94",
    email: "zohaibahmedbutt@gmail.com",
    name: "Zohaib Ahmed",
    password: "password"
  }

  setup %{conn: conn} do
    Repo.delete_all(Booking)
    Repo.delete_all(Location)
    Repo.delete_all(User)
    User.changeset(%User{}, @user_attrs) |> Repo.insert!()

    user = Repo.one(User)
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    connection = conn |> put_req_header("accept", "application/json") |> put_req_header("authorization", "bearer: " <> jwt)
    {:ok, conn: connection}
  end

  describe "POST /api/v1/toggle_monthly" do
    test "Toggle settings", %{conn: conn} do
      user = Repo.all(User) |> hd
      old_monthly_paying = user.monthly_paying

      conn = patch(conn, Routes.settings_path(conn, :toggle_monthly))
      assert response = json_response(conn, 200)

      # IO.inspect response

      user = Repo.all(User) |> hd
      new_monthly_paying = user.monthly_paying

      assert old_monthly_paying != new_monthly_paying
      assert %{"monthly_paying" => true} = json_response(conn, 200)
    end
  end
end
