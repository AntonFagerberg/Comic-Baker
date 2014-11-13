defmodule ComicBaker.ReaderController do
  use Phoenix.Controller
  
  alias ComicBaker.User
  alias ComicBaker.Session
  alias ComicBaker.Book
  alias Poison, as: JSON
  
  plug :authenticate
  plug :action
  
  defp base_dir do
    "/Users/anton/Desktop/CB"
  end
  
  defp authenticate(conn, _) do
    if Session.valid(conn) do
      conn
    else
      redirect conn, "/"
    end
  end
  
  def library(conn, _) do
    render conn, "library", books: Book.all get_session(conn, :email)
  end
  
  def upload(conn, %{"le_file" => %Plug.Upload{content_type: content_type, filename: filename, path: path}}) do
    book = Repo.insert %Book{title: filename, filename: filename, email: get_session(conn, :user), created: Ecto.DateTime.local}
    
    case String.slice filename, -3, 3 do
      "cbz" ->
        u_path = "#{base_dir}/#{book.id}"
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
  
  def read(conn, %{"id" => id}) do
    render conn, "page", api_url: ComicBaker.Router.Helpers.reader_path(:page_urls, id)
  end
  
  defp send_jpg(conn, file) do
    conn
    |> put_resp_header("content-type", Plug.MIME.path("image/jpeg"))
    |> send_file(200, file)
    |> halt
  end
  
  def cover(conn, %{"id" => id}) do
    {:ok, files} = File.ls("#{base_dir}/#{id}")
    {:ok, image} = files |> Enum.filter(&(String.slice &1, -4, 4) == ".jpg") |> Enum.fetch 0
    
    send_jpg conn, "#{base_dir}/#{id}/#{image}"
  end
  
  def page(conn, %{"id" => id, "img" => img}) do
    {:ok, files} = File.ls("#{base_dir}/#{id}")
    image = Enum.find files, &(&1 == img)
    
    send_jpg conn, "#{base_dir}/#{id}/#{image}"
  end
  
  def page_urls(conn, %{"id" => id}) do
    {:ok, files} = File.ls("#{base_dir}/#{id}")
    images = files |> Enum.filter(&(String.slice &1, -4, 4) == ".jpg") |> Enum.map(&(ComicBaker.Router.Helpers.reader_path(:page, id, &1)))
    
    json conn, JSON.encode!(images)
  end
end