defmodule ComicBaker.UserController do
  use Phoenix.Controller
  
  alias ComicBaker.Account
  alias ComicBaker.Session
  
  plug :not_authenticated when action in [:get_signup, :post_signup, :get_login, :post_login]
  plug :action
  
  defp not_authenticated(conn, _) do
    if !Session.valid(conn) do
      conn
    else
      conn
      |> redirect(ComicBaker.Router.Helpers.reader_path(:library))
      |> halt
    end
  end
  
  def get_signup(conn, _params) do
    render conn, "signup"
  end
  
  def post_signup(conn, %{"email" => email, "password" => password}) do
    salt = Enum.reduce(0..100, <<>>, fn(_, acc) -> <<:random.uniform(256)>> <> acc end)
    {:ok, hash_password} = :pbkdf2.pbkdf2(:sha512, password, salt, 20480, 160)
    
    # TODO Check if user exists
    Repo.insert %Account{email: email, salt: salt, password: hash_password}
    
    put_session(conn, :email, email)
    |> redirect(ComicBaker.Router.Helpers.reader_path(:library))
  end
  
  def get_login(conn, _) do
    render conn, "login"
  end
  
  def post_login(conn, %{"email" => email, "password" => password}) do
    user = Repo.get Account, email
    
    valid_login = 
      case user do
        %Account{email: email, password: user_password, salt: user_salt} ->
          {:ok, hash_password} = :pbkdf2.pbkdf2(:sha512, password, user_salt, 20480, 160)
          hash_password == user_password
        _ -> false
      end
    
    if valid_login do
      put_session(conn, :email, email)
      |> redirect(ComicBaker.Router.Helpers.reader_path(:library))
    else
      render conn, "login", email: email
    end
  end
  
  def logout(conn, _) do
    conn = delete_session(conn, :email)
    redirect conn, "/"
  end
end
