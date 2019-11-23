defmodule ParkingWeb.Router do
  use ParkingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Parking.AuthPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api/v1", ParkingWeb do
    pipe_through :api
    post "/register", UserController, :create
    post "/login", SessionController, :create
  end

  scope "/api/v1", ParkingWeb do
    pipe_through [:api, :jwt_authenticated]
    get "/user", UserController, :show
    post "/search", SearchController, :search
    resources "/bookings", BookingController, only: [:create]
  end
end
