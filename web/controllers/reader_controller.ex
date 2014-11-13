defmodule ComicBaker.ReaderController do
  use Phoenix.Controller
  
  alias ComicBaker.User
  alias ComicBaker.Session
  alias ComicBaker.Book
  
  #plug Plug.Parsers, length: 25_000_000, parsers: [:urlencoded, :multipart]
  plug :authenticate
  plug :action
  
  
  defp authenticate(conn, _) do
    if Session.valid(conn) do
      conn
    else
      text conn, 500, "Something went wrong"
    end
  end
  
  def library(conn, _) do
    render conn, "library", books: Book.all get_session(conn, :email)
  end
  
  def upload(conn, %{"le_file" => %Plug.Upload{content_type: content_type, filename: filename, path: path}}) do
    book = Repo.insert %Book{title: filename, filename: filename, email: get_session(conn, :user), created: Ecto.DateTime.local}
    
    case String.slice filename, -3, 3 do
      "cbz" ->
        u_path = "/Users/anton/Desktop/CB/#{book.id}"
        File.mkdir_p u_path
        
        case File.copy(path, "#{u_path}/#{filename}") do
          {:ok, x} -> 
            System.cmd "/usr/bin/unzip", ["-o", "#{u_path}/#{filename}", "-d", "#{u_path}"]
          {:error, x} -> IO.puts x
        end
      _ -> IO.puts "TODO error"
    end
    
    render conn, "library", books: Book.all get_session(conn, :email)
  end
end