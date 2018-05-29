defmodule UiWeb.Router do
  use UiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UiWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/upload", PageController, :upload_form
    post "/upload", PageController, :upload
    
    get "/hpgl", PageController, :hpgl
    post "/hpgl", PageController, :hpgl_post

    get "/debug", PageController, :debug

    get "/hello", PageController, :hello
    post "/hello", PageController, :hello_post
  end

  # Other scopes may use custom stacks.
  # scope "/api", UiWeb do
  #   pipe_through :api
  # end
end
