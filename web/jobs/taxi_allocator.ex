defmodule Takso.TaxiAllocator do
    use GenServer
    @decision_timeout Application.get_env(:takso, :decision_timeout)
    
    def start_link(request, booking_reference) do
        GenServer.start_link(Takso.TaxiAllocator, request, name: booking_reference)
    end
        
    def init(request) do
        Process.send_after(self(), :notify_customer, @decision_timeout)
        {:ok, request}
    end

    def accept_booking(booking_reference) do
        GenServer.cast(booking_reference, :accept_booking)
    end

    def handle_cast(:accept_booking, request) do
        {:noreply, request}
    end

    def handle_info(:notify_customer, request) do
        # With the following line, the backend is broadcasting a message through the channel "customer:lobby"
        # Henceforth, the following line must be updated for using private channels
        Takso.Endpoint.broadcast("customer:lobby", "requests", %{msg: "Our apologies, we cannot serve your request in this moment"})
        {:noreply, request}
    end
end