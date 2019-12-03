defmodule Parking.Worker do
  use GenServer
  alias Parking.Sales
   # Client

  def start_link(_param) do
    GenServer.start_link(__MODULE__, %{})
  end

  # Server (callbacks)

  @impl true
  def init(stack) do
    schedule_work()
    {:ok, stack}
  end


  @impl true
  def handle_info(:work, state) do
    Sales.update_location_statuses()
    Sales.find_extend_candidates()
    |> Enum.each(fn x -> ParkingWeb.Endpoint.broadcast("driver:" <> Integer.to_string(x) , "requests", %{msg: "Your parking time ends in 10 minutes. Would you like to extend your time?"}) end)
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 10 * 1000) # In 1 minute
  end
end
