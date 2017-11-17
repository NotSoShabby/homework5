defmodule Takso.Router do
  use Takso.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug Takso.Authentication, repo: Takso.Repo
  end

  pipeline :browser_auth do  
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end
  
  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated, handler: Takso.SessionController    
    plug :guardian_current_user
  end

  def guardian_current_user(conn, _) do
    Plug.Conn.assign(conn, :current_user, Guardian.Plug.current_resource(conn))
  end

  scope "/", Takso do
    pipe_through :browser # Use the default browser stack
    resources "/sessions", SessionController, only: [:new, :create]
  end

  scope "/", Takso do
    pipe_through [:browser, :browser_auth]
    get "/", PageController, :index
  end

  scope "/", Takso do
    pipe_through [:browser, :browser_auth, :require_login]

    resources "/users", UserController
    get "/bookings/summary", BookingController, :summary
    resources "/bookings", BookingController
    resources "/sessions", SessionController, only: [:delete]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :auth_api do
    plug Guardian.Plug.EnsureAuthenticated, handler: Takso.SessionAPIController    
    plug :guardian_current_user
  end

  scope "/api", Takso do
    pipe_through :api
    post "/sessions", SessionAPIController, :create
  end

  scope "/api", Takso do
    pipe_through [:api, :auth_api]
    delete "/sessions/:id", SessionAPIController, :delete
    post "/bookings", BookingAPIController, :create
    patch "/bookings/:id", BookingAPIController, :update
  end
end
