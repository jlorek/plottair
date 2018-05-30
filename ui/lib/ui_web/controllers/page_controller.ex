defmodule UiWeb.PageController do
  use UiWeb, :controller
  require Logger

  def index(conn, _params) do
    render conn, "index.html"
  end

  def upload_form(conn, _params) do
    render conn, "upload.html"
  end

  def upload(conn, %{"upload" => %{"command" => command}}) do
    # https://alexgaribay.com/2017/01/20/upload-files-to-s3-with-phoenix-and-ex_aws-2/
    conn
    |> put_flash(:info, "Received command '#{command}'")
    |> render("upload.html")
  end

  def hpgl(conn, _params) do
    hpgl = get_session(conn, :hpgl)
    Logger.info("hpgl = #{hpgl}")
    render(conn, "hpgl.html", hpgl: hpgl)
  end

  def hpgl_post(conn, params) do
    inspect(params)
    render(conn, "hpgl.html", hpgl: "foo")
  end

  def debug(conn, _params) do
    render(conn, "debug.html")
  end

  def hello(conn, _params) do
    render(conn, "hello.html")
  end

  def hello_post(conn, %{"points" => points}) do
    Logger.info("Points = #{points}")

    range = 0..100
    start = ["IN", "SC0,100,0,100", "SP1"]
    random_positions =  Enum.map(1..100, fn i -> "PD#{Enum.random(range)},#{Enum.random(range)}" end)
    stop = ["SP0", "PG"]

    # include signature at bottom

    commands = start ++ random_positions ++ stop
    hpgl = Enum.join(commands, ";\n") <> ";\n"

    Logger.info("hpgl =  #{hpgl}")

    conn
    |> put_session(:hpgl, hpgl)
    |> redirect(to: page_path(conn, :hpgl))
  end

  # def upload(conn, %{"upload" => %{"file" => file}}) do
  #   # https://alexgaribay.com/2017/01/20/upload-files-to-s3-with-phoenix-and-ex_aws-2/
  #   conn
  #   |> put_flash(:info, "Thanks for #{file.filename}, it's stored at #{file.path}")
  #   |> render("upload.html")
  # end
end
