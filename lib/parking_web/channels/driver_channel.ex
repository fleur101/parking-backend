defmodule ParkingWeb.DriverChannel do
  use ParkingWeb, :channel

  def join("driver:"<> user_id, _params, socket) do
    if authorized?(user_id, socket) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_out(event, payload, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(user_id, socket) do
    String.to_integer(user_id) === socket.assigns.current_user.user_id
  end
end
