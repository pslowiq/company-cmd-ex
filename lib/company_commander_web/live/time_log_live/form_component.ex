defmodule CompanyCommanderWeb.TimeLogLive.FormComponent do
  use CompanyCommanderWeb, :live_component

  alias CompanyCommander.Tasks


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage time log records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="time-log-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:user_id]} type="text" disabled="true" label="Name" />
        <.input field={@form[:start_time]} type="datetime-local" label="Start time" />
        <.input field={@form[:end_time]} type="datetime-local" label="End time" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Time Log</.button>
        </:actions>

      </.simple_form>

    </div>


    """
  end

  @impl true
  def update(%{time_log: time_log} = assigns, socket) do
    changeset = Tasks.change_time_log(time_log)
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"time_log" => time_log}, socket) do
    changeset =
      socket.assigns.form.source.data
      |> Tasks.change_time_log(time_log)
      |> Map.put(:action, :validate)
    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"time_log" =>  time_log}, socket) do
    save_time_log(socket, :edit, time_log)
    {:noreply, socket
                |> put_flash(:info, "Time log updated successfully")
                |> push_patch(to: socket.assigns.patch)}
  end

  defp save_time_log(socket, :edit, time_log) do
    case Tasks.update_time_log(socket.assigns.time_log, time_log) do
      {:ok, time_log} ->
        Phoenix.PubSub.broadcast(CompanyCommander.PubSub, "task#{time_log.task_id}", {:saved, time_log})

        {:noreply,
         socket
         |> put_flash(:info, "Time log updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
    assign(socket, :form, to_form(time_log))
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

end
