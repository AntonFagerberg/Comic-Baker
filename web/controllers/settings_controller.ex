defmodule ComicBaker.SettingsController do
  use Phoenix.Controller
  alias ComicBaker.Session

  plug :authenticate
  plug :action

  defp authenticate(conn, _) do
    if Session.valid(conn) do
      conn
    else
      conn
      |> redirect("/")
      |> halt
    end
  end

  def settings(conn, _) do
    render conn, "settings"
  end
end
