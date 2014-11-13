defmodule ComicBaker.ReaderController do
  use Phoenix.Controller
  
  alias ComicBaker.User
  alias ComicBaker.Session
  alias ComicBaker.Book
  alias Poison, as: JSON
  
  #plug Plug.Parsers, length: 25_000_000, parsers: [:urlencoded, :multipart]
  plug :authenticate
  plug :action
  
  defp base_dir do
    "/Users/anton/Desktop/CB"
  end
  
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
  
  def cover(conn, %{"id" => id}) do
    {:ok, files} = File.ls("#{base_dir}/#{id}")
    {:ok, image} = files |> Enum.filter(&(String.slice &1, -4, 4) == ".jpg") |> Enum.fetch 0
    
    conn
    |> put_resp_header("content-type", Plug.MIME.path("image/jpeg"))
    |> send_file(200, "#{base_dir}/#{id}/#{image}")
    |> halt
  end
  
  def page(conn, %{"id" => id, "img" => img}) do
    # TODO make sure user owns book
    {:ok, files} = File.ls("#{base_dir}/#{id}")
    #image = files |> Enum.filter files, fn(x) -> (String.slice x, -4, 4) == ".jpg" end
    image = Enum.find files, &(&1 == img)
    
    IO.puts image
    #image = files |> Enum.filter(&(String.slice &1, -4, 4) == ".jpg")
    
    #size = Enum.count images
    #{nr_i, _} = Integer.parse nr
    #{:ok, image} = Enum.fetch images, nr_i
    
    #cond do
      #nr_i <= size -> 
        conn
        |> put_resp_header("content-type", Plug.MIME.path("image/jpeg"))
        |> send_file(200, "#{base_dir}/#{id}/#{image}")
        |> halt
    #  true ->
    #    text conn, 500, "Something went wrong"
    #end
  end
  
  def page_urls(conn, %{"id" => id}) do
    {:ok, files} = File.ls("#{base_dir}/#{id}")
    images = files |> Enum.filter(&(String.slice &1, -4, 4) == ".jpg") |> Enum.map(&(ComicBaker.Router.Helpers.reader_path(:page, id, &1)))
    json conn, JSON.encode!(images)
  end
end