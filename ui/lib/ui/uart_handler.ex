defmodule Ui.UARTHandler do
   use GenServer
   require Logger
   alias Ui.UARTHandler

   defstruct [:uart]

   def start_link(opts \\ []) do
      args = Application.get_env(:ui, Ui.UARTHandler)[:device]
      GenServer.start_link(__MODULE__, args, opts)
   end

   def write(pid, data, wpc), do: GenServer.cast(pid, {:write, data, wpc})

   def init(args) do
     Logger.info("# init(#{args})")

     {:ok, pid} = Nerves.UART.start_link()
     :ok = Nerves.UART.open(pid, args, speed: 9600, active: false)
     Nerves.UART.configure(pid, framing: {Nerves.UART.Framing.Line, separator: ";\r\n"})
     
     Nerves.UART.write(pid, "IN")
     # knock knock
     Nerves.UART.write(pid, "PD")
     Nerves.UART.write(pid, "PU")
     Nerves.UART.write(pid, "PD")
     Nerves.UART.write(pid, "PU")

     {:ok, struct(UARTHandler, uart: pid)}
   end

   @imp true
   def handle_cast({:write, data, write_delay}, state) do
     commands = String.split(data, [";", "\r", "\n"], trim: true)

     Enum.each(commands, fn cmd ->
       Logger.info("Sending command: #{cmd}")

       :ok = Nerves.UART.write(state.uart, cmd)
       UiWeb.Endpoint.broadcast("room:lobby", "new_msg", %{body: "#{cmd};"})

       wait = String.length(cmd) * write_delay * command_multiplier(cmd)
       Logger.info("Delay #{wait}ms")
       :timer.sleep(wait);
     end)

     {:noreply, state}
   end

   defp command_multiplier(hpgl) do
    cond do
      String.starts_with?(hpgl, "LB") -> 22
      true -> 1
    end
   end
end