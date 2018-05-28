defmodule UiWeb.PageController do
  use UiWeb, :controller

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
    render(conn, "hpgl.html")
  end

  def debug(conn, _params) do
    render(conn, "debug.html")
  end

  # def upload(conn, %{"upload" => %{"file" => file}}) do
  #   # https://alexgaribay.com/2017/01/20/upload-files-to-s3-with-phoenix-and-ex_aws-2/
  #   conn
  #   |> put_flash(:info, "Thanks for #{file.filename}, it's stored at #{file.path}")
  #   |> render("upload.html")
  # end
end
