defmodule CompanyCommanderWeb.CompanyLive.Show do
  use CompanyCommanderWeb, :live_view

  alias CompanyCommander.Companies
  alias CompanyCommander.Tasks

  @impl true
  def mount(_params, session, socket) do
    current_user = CompanyCommander.Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
      socket
      |> assign(
        current_user: current_user
        )
      |> stream(:companies, Companies.get_companies_for_user(current_user.id))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    with company <- Companies.get_company!(id),
          tasks <- Tasks.get_tasks_for_company(company.id) do
        {:noreply,
          socket
          |> assign(:company, company)
          |> assign(:page_title, page_title(socket.assigns.live_action))
          |> stream(:tasks, tasks)}
      else
        {:error, _} ->
          {:noreply, redirect(socket, to: ~p"/")}
      end
  end

  @impl true
  def handle_info({CompanyCommanderWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  defp page_title(:show), do: "Show Company"
  defp page_title(:edit), do: "Edit Company"
  defp page_title(:new_company_task), do: "Add Company Task"
end