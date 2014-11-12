defmodule ComicBaker.ReaderController do
  use Phoenix.Controller
  
  alias ComicBaker.User
  alias ComicBaker.Session
  alias ComicBaker.Book
  
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
  
  def upload(conn, %{"le_file" => %Plug.Upload{content_type: content_type, filename: filename, path: path}}) do
    book = Repo.insert %Book{title: filename, filename: filename, email: get_session(conn, :user), created: Ecto.DateTime.local}
    
    IO.puts book.id
    
    # mkdir_p(Path.t) :: :ok | {:error, posix}

    File.mkdir_p "/Users/anton/Desktop/CB/#{book.id}/"
    
    
    case File.copy(path, "/Users/anton/Desktop/CB/#{book.id}/#{filename}") do
      {:ok, x} -> IO.puts x
      {:error, x} -> IO.puts x
    end
    render conn, "library"
  end
end