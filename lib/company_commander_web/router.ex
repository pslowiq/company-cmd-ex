defmodule CompanyCommanderWeb.Router do
  use CompanyCommanderWeb, :router

  defmacro mounter do

  end

  import CompanyCommanderWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CompanyCommanderWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug CompanyCommanderWeb.Plugs.NavigationHistory
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CompanyCommanderWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", CompanyCommanderWeb do
    pipe_through :browser

    live_session :companies_session,
      on_mount: [{CompanyCommanderWeb.UserAuth, :ensure_authenticated}] do
      live "/companies", CompanyLive.Index, :index
      live "/companies/new", CompanyLive.Index, :new
      live "/companies/:company_id/edit", CompanyLive.Index, :edit
      live "/companies/:company_id", CompanyLive.Show, :show
      live "/companies/:company_id/show/edit", CompanyLive.Show, :edit
      live "/companies/:company_id/new_company_task", CompanyLive.Show, :new_company_task

      live "/tasks", TaskLive.Index, :index

      live "/tasks/:task_id", TaskLive.Show, :show
      live "/tasks/:task_id/show/edit", TaskLive.Show, :edit
      live "/tasks/:task_id/show/edit/:time_log_id", TaskLive.Show, :edit_time_log

      live "/linkedin_automation", AutomationLive.LinkedinAutomationLive
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", CompanyCommanderWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:company_commander, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CompanyCommanderWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", CompanyCommanderWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{CompanyCommanderWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", CompanyCommanderWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{CompanyCommanderWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", CompanyCommanderWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{CompanyCommanderWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
