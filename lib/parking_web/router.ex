defmodule ParkingWeb.Router do
  use ParkingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_auth do
    plug Parking.AuthPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api/v1", ParkingWeb do
    pipe_through :api
    post "/register", UserController, :create
    post "/login", SessionController, :create
    post "/search_path", SearchController, :search
  end
end
