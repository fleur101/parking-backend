defmodule ParkingWeb.BookingController do
  use ParkingWeb, :controller

  alias Parking.Guardian
  alias Parking.Sales.Booking
  alias Parking.Sales

  action_fallback ParkingWeb.FallbackController

  def create(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    if params_present(params) do
      case Booking.create_booking_for(user, params) do
        {:ok, booking} -> conn |> render("create.json", booking)
        {:error, message} -> conn |> put_status(:unprocessable_entity) |> render("error.json", %{errors: message})
      end
    else
      conn |> put_status(:bad_request) |> render("error.json", %{errors: ["Some required parameters are missing"]})
    end
  end

  def params_present(params) do
    required_params = ["start_time", "end_time", "location_id", "pricing_type"]
    Enum.all?(required_params, fn required_param -> Map.has_key?(params, required_param) && params[required_param] != nil end)
  end

  def view(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    with  {:ok, bookings} <- Sales.view_bookings(user) do
      conn |> render("view.json", bookings: bookings)
    end
  end

end
