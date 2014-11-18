defmodule ComicBaker.SettingsController do
  use Phoenix.Controller
  alias ComicBaker.Session
  alias ComicBaker.Account

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

  def change_password(conn, %{"password" => %{"current" => password_current, "new" => password_new, "repeat" => password_repeat}}) do
    user = Repo.get Account, get_session(conn, :email)
    {:ok, hash_password} = :pbkdf2.pbkdf2(:sha512, password_current, user.salt, 20480, 160)

    cond do
      password_new !== password_repeat ->
        render conn, "settings", warning: "New passwords doesn't match!"
      hash_password !== user.password ->
        render conn, "settings", warning: "Current password was incorrect!"
      String.length(password_new) < 6 ->
        render conn, "settings", warning: "New password is too short!"
      true ->
        {:ok, new_hash_password} = :pbkdf2.pbkdf2(:sha512, password_new, user.salt, 20480, 160)
        Repo.update %{user | password: new_hash_password}
        redirect conn, ComicBaker.Router.Helpers.reader_path(:library)
    end
  end
end
