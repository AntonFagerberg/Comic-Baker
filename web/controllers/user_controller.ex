defmodule ComicBaker.UserController do
  use Phoenix.Controller
  
  alias ComicBaker.User
  alias ComicBaker.Session
  
  #plug :authenticate when action in [:upload_test]
  plug :action
  
  #defp authenticate(conn, _) do
  #  if Session.valid(conn) do
  #    conn
  #  else
  #    text conn, 500, "Something went wrong"
  #  end
  #end
  
  def get_sign_up(conn, _params) do
    render conn, "sign_up"
  end
  
  def post_sign_up(conn, %{"email" => email, "password" => password}) do
    salt = Enum.reduce(0..100, <<>>, fn(_, acc) -> <<:random.uniform(256)>> <> acc end)
    {:ok, hash_password} = :pbkdf2.pbkdf2(:sha512, password, salt, 20480, 160)
    
    # TODO Check if user exists
    Repo.insert %User{email: email, salt: salt, password: hash_password}
    
    render conn, "sign_up"
  end
  
  def get_login(conn, _) do
    render conn, "log_in"
  end
  
  def post_login(conn, %{"email" => email, "password" => password}) do
    user = Repo.get User, email
    
    valid_login = 
      case user do
        %User{email: email, password: user_password, salt: user_salt} ->
          {:ok, hash_password} = :pbkdf2.pbkdf2(:sha512, password, user_salt, 20480, 160)
          hash_password == user_password
        _ -> false
      end
    
    if valid_login do
      conn = put_session(conn, :user, email)
    end
    
    render conn, "log_in"
  end
  
  #def upload_test(conn, _params) do
  #  conn
  #  |> put_resp_header("content-type", Plug.MIME.path("image/png"))
  #  |> send_file(200, "/Users/anton/Documents/EarthBound\ at\ 22.02.06.png")
    #|> halt
    #render conn, "upload_test"
  #end
  
  #def index(conn, _params) do
    #IO.puts Repo.all(User)
    #users = Repo.all(User)
    #List.size(users)
    #{:ok, key} = :pbkdf2.pbkdf2(:sha512, "password", "salt", 20480, 160)

  #  render conn, "list", users: Repo.all(User) #"index", users: Repo.all(User)
  #end

  #def show(conn, %{"id" => id}) do
  #  case Repo.get(User, id) do
  #    user when is_map(user) -> render conn, "Showing user #{user}" #"show", user: user
  #    _ -> redirect conn, Router.page_path(page: "unauthorized")
  #  end
  #end

  #def new(conn, _params) do
  #  IO.puts "NEW!!!"
  #  render conn, "new"
  #end

  #def create(conn, %{"user" => %{"content" => content}}) do
  #  user = %User{content: content}
#
#    case User.validate(user) do
#      [] ->
#        user = Repo.insert(user)
#        render conn, "show", user: user
#      errors ->
#        render conn, "new", user: user, errors: errors
#    end
#  end
end
