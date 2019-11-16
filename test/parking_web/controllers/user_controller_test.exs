defmodule ParkingWeb.UserControllerTest do
  use ParkingWeb.ConnCase

  alias Parking.Accounts.User
  alias Parking.Repo

  @create_attrs %{
    password: "securepassword",
    name: "John Doe",
    username: "john87"
  }
  @existing_user_attrs %{
    password: "paulpassword",
    name: "Paul Shark",
    username: "paul33"
  }
  @invalid_attrs %{password: nil, name: nil, username: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    Repo.delete_all(User)
    User.changeset(%User{}, @existing_user_attrs) |> Repo.insert!()
    :ok
  end

  describe "register user" do
    test "registers when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"username" => username} = json_response(conn, 201)["data"]
    end

    test "returns errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "returns errors if such user already exist", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @existing_user_attrs)
      assert json_response(conn, 400)["errors"] != %{}
    end
  end


  @valid_login_attrs %{
    username: "paul33",
    password: "paulpassword"
  }
  @incorrect_password_attrs %{
    username: "paul33",
    password: "invalidpassword"
  }
  @incorrect_username_attrs %{
    username: "paul333",
    password: "paulpassword"
  }
  @invalid_fields_attrs %{
    username: nil,
    password: nil
  }

  describe "login user" do
    test "logs in when data is valid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), user: @valid_login_attrs)
      assert %{"data" => %{"username" => username}, "token" => token} = json_response(conn, 200)
    end

    test "returns error when incorrect password is entered", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), user: @incorrect_password_attrs)
      assert json_response(conn, 401)["errors"] != %{}
    end

    test "returns error if user does not exist", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), user: @incorrect_username_attrs)
      assert json_response(conn, 401)["errors"] != %{}
    end

    test "returns error if data is invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), user: @invalid_fields_attrs)
      assert json_response(conn, 400)["errors"] != %{}
    end
  end
end
