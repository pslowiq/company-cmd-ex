defmodule CompanyCommanderWeb.AutomationLive.LinkedinAutomationLive.LinkedinDogComponent do
  use CompanyCommanderWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
      for={@pass_form}
      id="pass-form"
      phx-target={@myself}
      phx-change="change_form"
      >
      <.input field={@pass_form["login"]} type="text" label="Login" />
      <.input field={@pass_form["password"]} type="password" label="Password" />
      </.simple_form>

      <%= if @linkedin_dog_pid do %>
      <.button phx-target={@myself} phx-click="stop-linkedin-dog" class="mt-8">
          Stop LinkedIn Dog
      </.button>
      <% else %>
      <.button phx-target={@myself} phx-click="run-linkedin-dog" class="mt-8">
          Run LinkedIn Dog
      </.button>
      <% end %>
    </div>
    """
  end

  def mount(_params, session, socket) do
    current_user = CompanyCommander.Accounts.get_user_by_session_token(session["user_token"])
    {:ok,
      socket
      |> assign(current_user: current_user)
    }
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign(linkedin_dog_pid: nil)
      |> assign(pass_form: to_form(%{"login" => "", "password" => ""}))}
  end

  @impl true
  def handle_event("change_form", %{"login" => login, "password" => password}, socket) do
    {:noreply,
      socket
      |> assign(pass_form: to_form(%{"login" => login, "password" => password}))
    }
  end

  def handle_event("run-linkedin-dog", _value, socket) do
    {:ok, pid} = CompanyCommander.LinkedinDog.start_link("linkedin-dog#{socket.assigns.current_user.id}}")
    GenServer.cast(pid, :start)
    GenServer.cast(pid,
      {:login, socket.assigns.pass_form.source["login"],
               socket.assigns.pass_form.source["password"]})
    {:noreply,
      socket
      |> assign(:linkedin_dog_pid, pid)}
  end

  def handle_event("stop-linkedin-dog", _value, socket) do
    GenServer.stop(socket.assigns.linkedin_dog_pid, :normal)
    {:noreply,
      socket
      |> assign(:linkedin_dog_pid, nil)}
  end

end
