defmodule CompanyCommanderWeb.CompanyLive.Show do
  use CompanyCommanderWeb, :live_view

  alias CompanyCommander.Companies
  alias CompanyCommander.Tasks
  alias CompanyCommander.Tasks.Task

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
  def handle_params(%{"company_id" => company_id}, _, socket) do
    Phoenix.PubSub.subscribe(CompanyCommander.PubSub, "company#{company_id}")
    with company <- Companies.get_preloaded_company!(company_id),
          tasks <- Tasks.get_tasks_for_company(company.id) do
        {:noreply,
          socket
          |> assign(:company, company)
          |> assign(:page_title, page_title(socket.assigns.live_action))
          |> stream(:tasks, tasks)
          |> assign(:company_user_options, Companies.make_user_options_for_company(company_id))
          |> assign(:task_user_options, Companies.make_user_options_for_new_company_task(company_id))}
      else
        {:error, _} ->
          {:noreply, redirect(socket, to: ~p"/")}
      end
  end

  @impl true
  def handle_info({:saved, %Task{} = task}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  defp page_title(:show), do: "Show Company"
  defp page_title(:edit), do: "Edit Company"
  defp page_title(:new_company_task), do: "Add Company Task"
end
