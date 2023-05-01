defmodule PosterAppWeb.Router do
  use PosterAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PosterAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug PosterAppWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :allowed_for_users do
    plug PosterAppWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug PosterAppWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  scope "/", PosterAppWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index

    get "/login", SessionController, :new

    post "/login", SessionController, :login

    get "/logout", SessionController, :logout

    get "/users/new", UserController, :new

    post "/users", UserController, :create

    get "/users", UserController, :index

    get "/users/:user_id", UserController, :show

    get "/users/:user_id/edit", UserController, :edit

    put "/users/:user_id", UserController, :update

    patch "/users/:user_id", UserController, :update

    delete "/users/:user_id", UserController, :delete

    get "/posts/new", PostController, :new

    post "/posts", PostController, :create

    get "/posts", PostController, :index

    get "/posts/:post_id/edit", PostController, :edit

    put "/posts/:post_id", PostController, :update

    patch "/posts/:post_id", PostController, :update

    delete "/posts/:post_id", PostController, :delete
  end

  scope "/", AuthWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/user_scope", PageController, :user_index
  end

  scope "/admin", PosterAppWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    resources "/users", UserController
    get "/", PageController, :admin_index
  end
  # Other scopes may use custom stacks.
  # scope "/api", PosterAppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PosterAppWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
