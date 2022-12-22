defmodule WobbleWeb.Router do
  use WobbleWeb, :router

  import WobbleWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {WobbleWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :simple_layout do
    plug(:put_root_layout, {WobbleWeb.Layouts, :authroot})
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", WobbleWeb do
    pipe_through([:browser, :simple_layout])

    get("/", PageController, :home)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WobbleWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:wobble, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: WobbleWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", WobbleWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated, :simple_layout])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{WobbleWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/organisation/register", OrgRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", WobbleWeb do
    pipe_through([:browser, :require_authenticated_user])

    get("/hello", HelloController, :index)

    live_session :require_authenticated_user,
      on_mount: [{WobbleWeb.UserAuth, :ensure_authenticated}] do
      live("/users", UserListLive, :index)
      live("/users/register", UserRegistrationLive, :new)
      live("/users/settings", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)
      live("/companies", CompanyLive.Index, :index)
      live("/companies/new", CompanyLive.Index, :new)
      live("/companies/:id/edit", CompanyLive.Index, :edit)

      live("/companies/:id", CompanyLive.Show, :show)
      live("/companies/:id/show/edit", CompanyLive.Show, :edit)
      live("/simple", SimpleForm)

      live("/organisation", OrganisationLive.Index, :index)
      live("/organisation/new", OrganisationLive.Index, :new)
      live("/organisation/:id/edit", OrganisationLive.Index, :edit)

      live("/organisation/:id", OrganisationLive.Show, :show)
      live("/organisation/:id/show/edit", OrganisationLive.Show, :edit)

      live "/company_users", CompanyUserLive.Index, :index
      live "/company_users/new", CompanyUserLive.Index, :new
      live "/company_users/:id/edit", CompanyUserLive.Index, :edit

      live "/company_users/:id", CompanyUserLive.Show, :show
      live "/company_users/:id/show/edit", CompanyUserLive.Show, :edit
    end
  end

  scope "/", WobbleWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{WobbleWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end
end
