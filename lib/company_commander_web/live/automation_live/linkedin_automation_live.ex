defmodule CompanyCommanderWeb.AutomationLive.LinkedinAutomationLive do
  use CompanyCommanderWeb, :live_view

  def mount(params, session, socket) do
    current_user = CompanyCommander.Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
      socket
      |> assign(current_user: current_user)
    }
  end
end
