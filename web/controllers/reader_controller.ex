defmodule ComicBaker.ReaderController do
  use Phoenix.Controller
  
  alias ComicBaker.User
  alias ComicBaker.Session
  
  plug :authenticate
  plug :action
  
  defp authenticate(conn, _) do
    if Session.valid(conn) do
      conn
    else
      text conn, 500, "Something went wrong"
    end
  end
  
  def get_library(conn, _) do
    render conn, "library"
  end
end