defmodule CompanyCommanderWeb.Plugs.NavigationHistory do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    history = get_session(conn, :history) || []
    history = [conn.request_path | history] |> Enum.take(10)
    conn |> put_session(:history, history)
  end
end
