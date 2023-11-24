defmodule ElixirCrudWeb.Router do
  use ElixirCrudWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirCrudWeb do
    pipe_through :api

    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    put "/users/:id", UserController, :update
    post "/users", UserController, :create
    delete "/users", UserController, :delete
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elixir_crud, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ElixirCrudWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
