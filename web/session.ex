defmodule ComicBaker.Session do
  use Phoenix.Controller
  
  alias ComicBaker.Account
  
  def valid(conn) do
    case get_session(conn, :email) do
      user_session ->
        case Repo.get Account, user_session do
          %Account{email: email} -> user_session == email
          _ -> false
        end
      _ -> false
    end
  end
end