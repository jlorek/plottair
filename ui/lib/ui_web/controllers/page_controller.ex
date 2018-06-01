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
    Logger.info("hpgl = #{hpgl}")
    render(conn, "hpgl.html", hpgl: hpgl)
  end

  def hpgl_post(conn, %{"hpgl" => hpgl, "wpc" => wpc} = params) do
    inspect(params)
    #render(conn, "hpgl.html", hpgl: "foo")
    Logger.info("hpgl = #{hpgl}")
    Logger.info("wpc = #{wpc}")
    Plotter.send(hpgl, wpc)

    conn
    |> put_session(:hpgl, hpgl)
    |> put_flash(:info, "Print job received.")
    |> redirect(to: page_path(conn, :console))
  end

  def debug(conn, _params) do
    render(conn, "debug.html")
  end

  def hello(conn, _params) do
    render(conn, "hello.html")
  end

  def hello_post(conn, %{"points" => points, "pens" => pens, "signature" => signature}) do
    Logger.info("Points = #{points}")
    
    points = case Integer.parse(points) do
      {integer, fraction} -> integer
      :error -> 100
    end
    
    pens = case Integer.parse(pens) do
      {integer, fraction} -> integer
      :error -> 1
    end
    
    # some ranges from
    # https://github.com/tobiastoft/SymbolicDisarray
    # -- PLOTTER --
    # --  front  --
    # 602 - y - 10602
    # 170
    # |
    # x
    # |
    # 15370

    init = ["IN", "SP1"]

    xPos = 10602
    yPos = 1863
    signature = case String.length(signature) do
      0 -> []
      _ -> ["PU#{xPos},#{yPos}", "SI0.2,0.2", "DI0,1", "DT.", "LB#{signature}."]
    end
    
    scale = ["SC0,100,0,100"]
    range = 0..100
    random_positions =  Enum.map(1..points, fn i -> "PD#{Enum.random(range)},#{Enum.random(range)}" end)
    stop = ["SP0", "PG"]

    commands = init ++ signature ++ scale ++ random_positions ++ stop
    hpgl = Enum.join(commands, ";\n") <> ";\n"

    conn
    |> put_session(:hpgl, hpgl)
    |> redirect(to: page_path(conn, :hpgl))
  end
end
