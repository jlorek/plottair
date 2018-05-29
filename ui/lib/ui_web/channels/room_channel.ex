defmodule UiWeb.RoomChannel do
  use Phoenix.Channel
  require Logger
  alias Ui.Plotter

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    #broadcast! socket, "new_msg", %{body: body}
    Plotter.send(body)
    {:noreply, socket}
  end

  def handle_in("hpgl", %{"commands" => commands}, socket) do
    Logger.info("Received HPGL commands")
  end

end