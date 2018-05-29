defmodule Ui.Plotter do
  require Logger

  @baudrate 9600
  @debug true
  @delay 3

  def send(hpgl) do
    Logger.info("Received HPGL: #{hpgl}")
    UiWeb.Endpoint.broadcast("room:lobby", "new_msg", %{body: hpgl})
  end

end