defmodule DoctorScheduleWeb.Router do
  use DoctorScheduleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DoctorScheduleWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug DoctorScheduleWeb.Auth.Pipeline
  end

  scope "/", DoctorScheduleWeb do
    pipe_through [:browser, :auth]

    get "/logout", SessionController, :logout
    live "/", PageLive, :index
  end

  scope "/", DoctorScheduleWeb do
    pipe_through :browser

    get "/session", SessionController, :session
    post "/signin", SessionController, :login_create
    post "/signup", SessionController, :create_account
    get "/forgot-password", ForgotPasswordController, :forgot_password
    post "/forgot-password", ForgotPasswordController, :forgot_password_create
  end

  # Other scopes may use custom stacks.
  scope "/api", DoctorScheduleWeb.Api, as: :api do
    pipe_through :api

    post "/password/reset", ResetPasswordController, :create
    post "/password/forgot", PasswordForgotController, :create
    resources "/sessions", SessionController
    resources "/users", UserController, only: [:create]
  end

  scope "/api", DoctorScheduleWeb.Api, as: :api do
    pipe_through [:api, :auth]

    get "/providers/:provider_id/day-availability/:date", ProviderDayAvailabilityController, :show
    get "/providers/:provider_id/month-availability", ProviderMonthAvailabilityController, :show
    resources "/appointments", AppointmentController
    resources "/users", UserController, except: [:create]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # coveralls-ignore-start
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DoctorScheduleWeb.Telemetry
    end
  end

  # coveralls-ignore-stop
end
