defmodule ComicBaker.MainController do
  use Phoenix.Controller
  
  alias ComicBaker.Session
  
  plug :not_authenticated
  plug :action
  
  def not_authenticated(conn, _) do
    if !Session.valid(conn) do
      conn
    else
      redirect conn, ComicBaker.Router.Helpers.reader_path(:get_library)
    end
  end
  
  def main(conn, _) do
    render conn, "main"
  end
end