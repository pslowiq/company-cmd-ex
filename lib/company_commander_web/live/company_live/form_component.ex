defmodule CompanyCommanderWeb.CompanyLive.FormComponent do
  use CompanyCommanderWeb, :live_component

  alias CompanyCommander.Companies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage company records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="company-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:contact_info]} type="text" label="Contact info" />
        <.input field={@form[:domain]} type="text" label="Domain" />
        <.multi_select
          id="multi-select-component"
          form={@form}
          on_change= {fn selected -> send_update(self(), @myself, %{selected_users: selected}) end}
          wrap={false}
          placeholder="Select users..."
          title="Select tipics to filter quotes"
          options={@selected_users}
          class="w-full"
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Company</.button>
        </:actions>

      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{company: company} = assigns, socket) do
    changeset = Companies.change_company(company)
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:selected_users, assigns.selected_users)
     |> assign_form(changeset)}
  end

  @impl true
  def update(%{selected_users: selected_users} = assigns, socket) do
    {:ok,
     socket
     |> assign(:selected_users, assigns.selected_users)}
  end

  @impl true
  def handle_event("validate", %{"company" => company_params}, socket) do
    changeset =
      socket.assigns.company
      |> Companies.change_company(company_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"company" => company_params}, socket) do
    company_params = Map.put(company_params, "user_ids", socket.assigns.selected_users |> Enum.filter(& &1.selected)|> Enum.map(& &1.id))
    save_company(socket, socket.assigns.action, company_params)
  end

  defp save_company(socket, :edit, company_params) do
    case Companies.update_company(socket.assigns.company, company_params) do
      {:ok, company} ->
        #notify_parent({:saved, company})
        Phoenix.PubSub.broadcast(CompanyCommander.PubSub, "companies", {:saved, company})

        {:noreply,
         socket
         |> put_flash(:info, "Company updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_company(socket, :new, company_params) do
    case Companies.create_company(company_params) do
      {:ok, company} ->
        Phoenix.PubSub.broadcast(CompanyCommander.PubSub, "companies", {:saved, company})
        user = socket.assigns.current_user
        {:ok, _} = Companies.create_company_user(%{"company_id" => company.id, "user_id" => user.id})

        {:noreply,
         socket
         |> put_flash(:info, "Company created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

end
