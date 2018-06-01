defmodule Ui.UARTHandler do
   use GenServer
   require Logger
   alias Ui.UARTHandler
   defstruct [:uart]

   #def start_link(opts), do: GenServer.start_link(__MODULE__, "ttyAMA0", opts)
   def start_link(opts), do: GenServer.start_link(__MODULE__, "tty.usbserial", opts)

   def write(plotter, data), do: GenServer.cast(plotter, {:write, data})

   def init(args) do
     Logger.info("### init(#{args})")
     {:ok, pid} = Nerves.UART.start_link()
     #:ok = Nerves.UART.open(pid, "ttyAMA0", speed: 9600, active: false)
     :ok = Nerves.UART.open(pid, args, speed: 9600, active: false)
     Nerves.UART.configure(pid, framing: {Nerves.UART.Framing.Line, separator: "\r\n"})
     {:ok, struct(UARTHandler, uart: pid)}
   end

   @imp true
   def handle_cast({:write, data}, state) do
     Logger.info("### write(#{data})")
     IO.inspect(state)
     :ok = Nerves.UART.write(state.uart, data)
     {:noreply, state}
   end

   def handle_call({:interact, timeout}, _from, state) do
     :ok = Nerves.UART.write(state.uart, "SOME FORMATTED BINARY")
     case Nerves.UART.read(state.uart, timeout) do
       {:ok, data} -> {:reply, {:ok, data}, state}
       {:error, reason} -> {:reply, {:error, reason}, state}
     end
   end
end