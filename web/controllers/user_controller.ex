defmodule ComicBaker.UserController do
  use Phoenix.Controller

  plug :action

  #use Jazz
  alias ComicBaker.Router
  alias ComicBaker.User

  def index(conn, _params) do
    #IO.puts Repo.all(User)
    #users = Repo.all(User)
    #List.size(users)
    #{:ok, key} = :pbkdf2.pbkdf2(:sha512, "password", "salt", 20480, 160)

    render conn, "list", users: Repo.all(User) #"index", users: Repo.all(User)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      user when is_map(user) -> render conn, "Showing user #{user}" #"show", user: user
      _ -> redirect conn, Router.page_path(page: "unauthorized")
    end
  end

  def new(conn, _params) do
    IO.puts "NEW!!!"
    render conn, "new"
  end

  def create(conn, %{"user" => %{"content" => content}}) do
    user = %User{content: content}

    case User.validate(user) do
      [] ->
        user = Repo.insert(user)
        render conn, "show", user: user
      errors ->
        render conn, "new", user: user, errors: errors
    end
  end
end
