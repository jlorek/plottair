defmodule UiWeb.PageController do
  use UiWeb, :controller
  require Logger
  alias Ui.Plotter

  def index(conn, _params) do
    render conn, "index.html"
  end

  def console(conn, _params) do
    render(conn, "console.html")
  end

  def hpgl(conn, _params) do
    hpgl = get_session(conn, :hpgl)
    render(conn, "hpgl.html", hpgl: hpgl)
  end

  def hpgl_post(conn, %{"hpgl" => hpgl, "wpc" => wpc}) do
    Logger.info("hpgl = #{hpgl}")
    Logger.info("wpc = #{wpc}")
    Plotter.send(hpgl, wpc)

    conn
    |> put_session(:hpgl, hpgl)
    |> put_flash(:info, "Print job received.")
    |> redirect(to: page_path(conn, :console))
  end

  def hello(conn, _params) do
    render(conn, "hello.html")
  end

  def hello_post(conn, %{"points" => points, "pens" => pens, "signature" => signature}) do
    points = case Integer.parse(points) do
      {integer, _fraction} -> integer
      :error -> 100
    end
    
    pens = case Integer.parse(pens) do
      {integer, _fraction} -> integer
      :error -> 1
    end
    
    hpgl = Ui.HpglHello.generate(points, pens, signature)

    conn
    |> put_session(:hpgl, hpgl)
    |> redirect(to: page_path(conn, :hpgl))
  end

  def debug(conn, _params) do
    render(conn, "debug.html")
  end
end
