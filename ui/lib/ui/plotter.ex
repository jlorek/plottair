defmodule Ui.Plotter do
  require Logger
  alias Ui.UARTHandler

  @baudrate 9600
  @debug true
  @delay 3

  def init() do
    Logger.info("Starting Nerves.UART...")  
    Nerves.UART.start_link(name: Plotter)
    Nerves.UART.open(Plotter, "ttyAMA0", speed: 9600, active: false)
  end

  def send(hpgl) do
    Logger.info("Received HPGL: #{hpgl}")

    if (hpgl == "open") do
      init()
    else
      UARTHandler.write(GlobalHandler, hpgl)
      #Nerves.UART.write(Plotter, hpgl)
    end
    
    UiWeb.Endpoint.broadcast("room:lobby", "new_msg", %{body: hpgl})
  end

#https://elixirforum.com/t/nerves-uart-write-doesnt-work-from-phoenix-controller/13333/3
#Nerves.UART.enumerate
#{:ok, pid} = Nerves.UART.start_link
#Nerves.UART.open(pid, "ttyS0", speed: 9600, active: true)
#Nerves.UART.open(pid, "ttyAMA0", speed: 9600, active: true)
#Nerves.UART.configuration(pid)
#Nerves.UART.write(pid, "IN;SP1;\r\n")
#Nerves.UART.write(pid, "IN;SP2;\r\n")
#Nerves.UART.write(pid, "SP1;\r\n")
#Nerves.UART.write(pid, "SP2;\r\n")
#Nerves.UART.configure(pid, active: true)
#flush
#Nerves.UART.close(pid)
#Nerves.UART.stop(pid)

end