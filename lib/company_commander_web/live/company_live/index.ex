defmodule CompanyCommanderWeb.CompanyLive.Index do
  use CompanyCommanderWeb, :live_view

  alias CompanyCommander.Companies
  alias CompanyCommander.Companies.Company

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(CompanyCommander.PubSub, "companies")

    {:ok,
      socket
      |> assign(
        page_title: "Listing Companies")
      |> stream(:companies, Companies.get_companies_for_user(socket.assigns.current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Company")
    |> assign(:company, Companies.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Company")
    |> assign(:company, %Company{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Companies")
    |> assign(:company, nil)
  end

  @impl true
  def handle_info({:saved, company}, socket) do
    # check if current_user belongs to company
    case Companies.get_company_user(company.id, socket.assigns.current_user.id) do
      nil ->
        {:noreply, socket}
      %CompanyCommander.Companies.CompanyUser{} ->
        {:noreply, stream_insert(socket, :companies, company)}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    company = Companies.get_company!(id)
    {:ok, _} = Companies.delete_company(company)

    {:noreply, stream_delete(socket, :companies, company)}
  end
end
