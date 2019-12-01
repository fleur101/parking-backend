defmodule ParkingWeb.PaymentView do
  use ParkingWeb, :view

  def render("create.json", %{payment: payment}) do
    %{id: payment.id, amount: payment.amount, stripe_charge_id: payment.stripe_charge_id}
  end

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end
