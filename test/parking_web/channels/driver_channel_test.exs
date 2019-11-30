defmodule ParkingWeb.DriverChannelTest do
  use ParkingWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      socket(ParkingWeb.UserSocket, "1", %{current_user: %{user_id: 1}})
      |> subscribe_and_join(ParkingWeb.DriverChannel, "driver:1")

    {:ok, socket: socket}
  end


  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
