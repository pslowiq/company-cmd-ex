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
        id="company-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:finished]} type="checkbox" label="Is finished?" />
        <.input field={@form[:company_id]} type="number" label="Company Id"/>

        <:actions>
          <.button phx-disable-with="Saving...">Save Task</.button>
        </:actions>

      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:task, %Tasks.Task{})}
  end

  @impl true
  def update(%{company: company} = assigns, %{assigns: %{task: task}} = socket) do
    changeset = Tasks.change_task(task, %{company_id: company.id})
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def update(assigns, %{assigns: %{task: task}} = socket) do
    changeset = Tasks.change_task(task)
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      socket.assigns.form.source.data
      |> Tasks.change_task(task_params)
      |> Map.put(:action, :validate)
    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.action, task_params)
  end

  defp save_task(socket, :new_company_task, task_params) do
    case Tasks.create_preloaded_task(task_params) do
      {:ok, task} ->
        notify_parent({:saved, task})

        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_task(socket, :edit, task_params) do
    case Tasks.update_task(socket.assigns.task, task_params) do
      {:ok, task} ->
        notify_parent({:saved, task})

        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_task(socket, :new, task_params) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        notify_parent({:saved, task})

        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
