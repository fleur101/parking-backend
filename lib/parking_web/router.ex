defmodule ParkingWeb.Router do
  use ParkingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", ParkingWeb do
    pipe_through :api
    post "/register", UserController, :create
  end
end
