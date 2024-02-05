defmodule CompanyCommanderWeb.TaskLive.FormComponent do

  use CompanyCommanderWeb, :live_component

  alias CompanyCommander.Tasks

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tasks records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="task-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:finished]} type="checkbox" label="Is finished?" />
        <.input field={@form[:company_id]} type="hidden"/>

        <.label>Assign users</.label>
        <.multi_select
          id="multi-select-component"
          form={@form}
          on_change= {fn selected -> send_update(self(), @myself, %{selected_users: selected}) end}
          wrap={false}
          placeholder="Assign users to the task..."
          title="Select tipics to filter quotes"
          options={@selected_users}
          class="w-full !mt-[0.125rem]"
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Task</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{company: company} = assigns, %{assigns: %{task: task}} = socket) do
    changeset = Tasks.change_task(task, %{company_id: company.id})
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:selected_users, assigns.selected_users)
     |> assign_form(changeset)}
  end

  @impl true
  def update(%{task: task} = assigns, socket) do
    changeset = Tasks.change_task(task, %{company_id: task.company_id})
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:selected_users, assigns.selected_users)
     |> assign_form(changeset)}
  end

  @impl true
  def update(%{selected_users: selected_users}, socket) do
    {:ok,
     socket
     |> assign(:selected_users, selected_users)}
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      socket.assigns.form.source.data
      |> Tasks.change_task(task_params)
      |> Map.put(:action, :validate)
    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.action, Map.put(task_params, "user_ids", Enum.filter(socket.assigns.selected_users, & &1.selected) |> Enum.map(& &1.id)))
  end

  defp save_task(socket, :new_company_task, task_params) do
    case Tasks.create_preloaded_task(task_params) do
      {:ok, task} ->
        Phoenix.PubSub.broadcast(CompanyCommander.PubSub, "company#{task.company_id}", {:saved, task})

        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_task(socket, :edit, task_params) do
    case Tasks.update_task_and_preload(socket.assigns.task, task_params) do
      {:ok, task} ->
        Phoenix.PubSub.broadcast(CompanyCommander.PubSub, "company#{task.company_id}", {:saved, task})

        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

end
