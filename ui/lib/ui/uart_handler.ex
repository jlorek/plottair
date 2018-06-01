defmodule Ui.UARTHandler do
   use GenServer
   require Logger
   alias Ui.UARTHandler

   @ms_per_char 10

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
     {:ok, struct(UARTHandler, uart: pid)}
   end

   @imp true
   def handle_cast({:write, data, wpc}, state) do
     Logger.info("# write(#{data})")
     IO.inspect(state)

     commands = String.split(data, [";", "\r", "\n"], trim: true)
     Enum.each(commands, fn cmd ->
       Logger.info("Sending command: #{cmd}")
       :ok = Nerves.UART.write(state.uart, cmd)
       UiWeb.Endpoint.broadcast("room:lobby", "new_msg", %{body: cmd})
       wait = String.length(cmd) * wpc
       :timer.sleep(wait);
     end)

     {:noreply, state}
   end

#    def handle_call({:interact, timeout}, _from, state) do
#      :ok = Nerves.UART.write(state.uart, "SOME FORMATTED BINARY")
#      case Nerves.UART.read(state.uart, timeout) do
#        {:ok, data} -> {:reply, {:ok, data}, state}
#        {:error, reason} -> {:reply, {:error, reason}, state}
#      end
#    end
end