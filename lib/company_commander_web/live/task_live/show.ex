defmodule CompanyCommanderWeb.TaskLive.Show do
  alias CompanyCommander.Companies
  use CompanyCommanderWeb, :live_view

  alias CompanyCommander.Tasks
  alias CompanyCommander.Tasks.TimeLog
  alias Phoenix.LiveView.Components.MultiSelect.Option

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"task_id" => task_id, "time_log_id" => time_log_id}, _, socket) do
    Phoenix.PubSub.subscribe(CompanyCommander.PubSub, "task#{task_id}")

    {:noreply, socket
    |> default_assigns(task_id)
    |> assign(:time_log, Tasks.get_time_log!(time_log_id))}
  end

  @impl true
  def handle_params(%{"task_id" => task_id}, _, socket) do
    Phoenix.PubSub.subscribe(CompanyCommander.PubSub, "task#{task_id}")

    {:noreply, socket
                |> default_assigns(task_id)}

  end

  @impl true
  def handle_event("time_tracking", _value, %{assigns: %{current_user_tracks_time: false}} = socket) do
    ret = Tasks.start_tracking_time(socket.assigns.task.id, socket.assigns.current_user.id)
    case ret do
      {:ok, time_log} ->
        Phoenix.PubSub.broadcast(CompanyCommander.PubSub, "task#{socket.assigns.task.id}", {:saved, time_log})
        {:noreply, socket
                    |> assign(:current_user_tracks_time, true)
                    |> put_flash(:info, "Time tracking started successfully")}
      {:error, _} ->
        {:noreply, socket
                    |> put_flash(:error, "Error starting time tracking")}
    end
  end

  @impl true
  def handle_event("time_tracking", _value, %{assigns: %{current_user_tracks_time: true}} = socket) do
    case Tasks.stop_tracking_time(socket.assigns.task.id, socket.assigns.current_user.id) do
      {:ok, time_log} ->
        Phoenix.PubSub.broadcast(CompanyCommander.PubSub, "task#{socket.assigns.task.id}", {:saved, time_log})
        {:noreply, socket
                    |> assign(:current_user_tracks_time, false)
                    |> put_flash(:info, "Time tracking stopped successfully")}
      {:error, _} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:saved, %TimeLog{} = time_log}, socket) do
    {:noreply, stream_insert(socket, :time_logs, time_log)}
  end

  defp page_title(:show), do: "Show Task"
  defp page_title(:edit), do: "Edit Task"
  defp page_title(:edit_time_log), do: "Edit Time Log"

  defp default_assigns(socket, task_id) do
    task = Tasks.get_task!(task_id)
    company = Companies.get_company!(task.company_id)
    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:task, task)
    |> stream(:time_logs, Tasks.get_time_logs_for_task(task.id))
    |> assign(:company, company)
    |> assign(:current_user_tracks_time, Tasks.check_if_user_is_tracking_time(task.id, socket.assigns.current_user.id) )
    |> assign(:user_options, Tasks.make_user_options_for_task(task.id, company.id))

  end
end
