defmodule Ui.Plotter do
  require Logger
  alias Ui.UARTHandler

  def send(hpgl) do
    Logger.info("Executing HPGL: #{hpgl}")
    UARTHandler.write(GlobalUART, hpgl)
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