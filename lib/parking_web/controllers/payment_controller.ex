defmodule ParkingWeb.PaymentController do
  use ParkingWeb, :controller

  alias Parking.Guardian
  alias Parking.Sales.Payment

  action_fallback ParkingWeb.FallbackController

  def create(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    if params_present(params) do
      case Payment.create_payment_for(user, params) do
        {:ok, payment} -> conn |> render("create.json", payment)
        {:error, message} -> conn |> put_status(:unprocessable_entity) |> render("error.json", %{errors: message})
      end
    else
      conn |> put_status(:bad_request) |> render("error.json", %{errors: ["Some required parameters are missing"]})
    end
  end
  def params_present(params) do
    required_params = ["booking_id", "stripe_token"]
    Enum.all?(required_params, fn required_param -> Map.has_key?(params, required_param) && params[required_param] != nil end)
  end
end
