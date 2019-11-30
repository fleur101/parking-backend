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
    IO.puts "Updating availability"
    Parking.Sales.update_location_statuses()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 10 * 1000) # In 1 minute
  end
end
