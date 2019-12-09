defmodule ParkingWeb.BookingView do
  use ParkingWeb, :view

  def render("create.json", %{booking: booking}) do
    %{id: booking.id, location_id: booking.location_id, payment_status: booking.payment_status, booked_by: booking.user.name, pricing_zone: booking.location.pricing_zone, pricing_type: booking.pricing_type}
  end

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end
