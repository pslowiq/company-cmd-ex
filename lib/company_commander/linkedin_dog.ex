defmodule CompanyCommander.LinkedinDog do
  use Hound.Helpers
  use GenServer
  require Logger

  @default_x_pos 0
  @default_y_pos 0
  @default_x_size 1200
  @default_y_size 1200
  @default_port 9515

  def start_link(name, opts \\ %{}) do
    args =
    %{}
    |> Map.put("x_pos", Map.get(opts, "x_pos", @default_x_pos))
    |> Map.put("y_pos", Map.get(opts, "y_pos", @default_y_pos))
    |> Map.put("port", Map.get(opts, "port", @default_port))

    start_chromedriver()
    state = {:not_started, args}
    GenServer.start_link(__MODULE__, state, name: {:global, name})
  end

  @impl true
  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  @impl true
  def handle_cast(:start, {:not_started, state}) do
    x_pos = Map.get(state, "x_pos")
    y_pos = Map.get(state, "y_pos")

    Hound.start_session
    main_page()
    current_window_handle()
    |> set_window_size(@default_x_size, @default_y_size)
    |> set_window_position(x_pos, y_pos)
    {:noreply, {:started, state}}
  end

  @impl true
  def handle_cast({:login, username, password}, {:started, state}) do
    login(username, password)
    {:noreply, {:started, state}}
  end

  #todo: implement this
  @impl true
  def handle_cast({:send_message, message, to}, {:started, state}) do
    Logger.debug("Sending message: #{message} #{to}")
    {:noreply, {:started, state}}
  end

  #todo: implement this
  @impl true
  def handle_call({:scrape_search, sn_url}, _from, {:started, state}) do
    Logger.debug("Scraping search: #{sn_url}")
    {:noreply, {:started, state}}
  end

  defp start_chromedriver(port \\ @default_port) do
    Logger.debug("Starting chromedriver on port #{port}")

    with {:ok, path} <- File.cwd do
      _task = Task.start(
        fn ->
          System.cmd(path <> "/chromedriver", ["--port=#{port}"])
        end
      )
      Logger.debug("Chromedriver started")
    end
  end

  def main_page do
    inspected_navigate_to("https://www.google.com")
  end

  def login(username, password) do
    inspected_navigate_to("https://www.linkedin.com/login")
    find_element(:id, "username")
    |> fill_field(username)
    find_element(:id, "password")
    |> fill_field(password)
    find_element(:xpath, "//*[@aria-label='Sign in']")
    |> click()
  end

  defp inspected_navigate_to(url) do
    Logger.debug("Navigating to #{url}")
    navigate_to(url)
    Logger.debug("Page title: #{page_title()}")
  end

  @impl true
  def handle_info({:EXIT, _from_pid, reason}, state) do
    Logger.debug("Process died because of #{reason}")
    {:noreply, state}
  end

  @impl true
  def terminate(reason, {_status, _state}) do
    Logger.debug("Terminating, reason: #{inspect(reason)}")
    Hound.end_session
    :ok
  end
end
