defmodule ComicBaker.MainController do
  use Phoenix.Controller
  
  plug :action
  
  def main(conn, _) do
    render conn, "main"
  end
end