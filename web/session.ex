defmodule ComicBaker.Session do
  use Phoenix.Controller
  
  alias ComicBaker.User
  
  def valid(conn) do
    case get_session(conn, :user) do
      user_session ->
        case Repo.get User, user_session do
          %User{email: email} -> user_session == email
          _ -> false
        end
      _ -> false
    end
  end
end