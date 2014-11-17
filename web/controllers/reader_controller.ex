defmodule ComicBaker.ReaderController do
  use Phoenix.Controller

  alias ComicBaker.Session
  alias ComicBaker.Book
  alias Poison, as: JSON

  plug :authenticate
  plug :action

  @base_dir "/Users/anton/Desktop/CB"

  defp authenticate(conn, _) do
    if Session.valid(conn) do
      conn
    else
      conn
      |> redirect("/")
      |> halt
    end
  end

  def library(conn, _) do
    render conn, "library", books: ((Book.all get_session(conn, :email)) |> Enum.sort (&(&1.title < &2.title)))
  end

  def upload(conn, %{"file" => %Plug.Upload{content_type: content_type, filename: filename, path: path}}) do
    case String.slice filename, -3, 3 do
      "cbz" ->
        book = Repo.insert %Book{title: filename, filename: filename, email: get_session(conn, :email), created: Ecto.DateTime.local}
        u_path = "#{@base_dir}/#{book.id}"
        File.mkdir_p u_path

        case File.copy(path, "#{u_path}/#{filename}") do
          {:ok, _} ->
            System.cmd "/usr/bin/unzip", ["-j", "-o", "#{u_path}/#{filename}", "-d", "#{u_path}"]
          {:error, x} ->
            IO.puts x
        end
      _ -> IO.puts "TODO error"
    end

    redirect conn, ComicBaker.Router.Helpers.reader_path(:library)
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

  defp valid_extension(filename) do
    [".jpg", ".jpeg"] |> Enum.any?(&(&1 == String.slice filename, -(String.length &1), String.length &1))
  end

  def cover(conn, %{"id" => id}) do
    {id_int, _} = Integer.parse id

    if Book.get(id_int, get_session(conn, :email)) != nil do
      {:ok, files} = File.ls("#{@base_dir}/#{id}")

      {:ok, image} = files
      |> Enum.sort(&(String.downcase(&1) < String.downcase(&2)))
      |> Enum.filter(&(valid_extension &1))
      |> Enum.fetch 0

      send_jpg conn, "#{@base_dir}/#{id}/#{image}"
    else
      text conn, 401, "Unauthorized access!"
    end
  end

  def save_page(conn, %{"id" => id, "img" => img}) do
    {id_int, _} = Integer.parse id
    book = Book.get(id_int, get_session(conn, :email))

    if book != nil do
      {:ok, files} = File.ls("#{@base_dir}/#{id}")
      images = files
      |> Enum.sort(&(String.downcase(&1) < String.downcase(&2)))
      |> Enum.filter(&(valid_extension &1))
      |> Enum.with_index

      {_, page} = Enum.find images, fn{image, _} -> image == URI.decode_www_form(img) end
      Repo.update %{book | page: page}
      text conn, 200, "page saved"
    else
      text conn, 404, "page not found"
    end
  end

  def page(conn, %{"id" => id, "img" => img}) do
    {id_int, _} = Integer.parse id
    book = Book.get(id_int, get_session(conn, :email))

    if book != nil do
      {:ok, files} = File.ls("#{@base_dir}/#{id}")
      images = files
      |> Enum.sort(&(String.downcase(&1) < String.downcase(&2)))
      |> Enum.filter(&(valid_extension &1))
      |> Enum.with_index

      {image, page} = Enum.find images, fn{image, _} -> image == URI.decode_www_form(img) end
      send_jpg conn, "#{@base_dir}/#{id}/#{image}"
    else
      text conn, 401, "Unauthorized access!"
    end
  end

  def page_urls(conn, %{"id" => id}) do
    {id_int, _} = Integer.parse id
    book = Book.get(id_int, get_session(conn, :email))

    if book != nil do
      {:ok, files} = File.ls("#{@base_dir}/#{id}")
      urls = files
      |> Enum.sort(&(String.downcase(&1) < String.downcase(&2)))
      |> Enum.filter(&(valid_extension &1))
      |> Enum.map(&(ComicBaker.Router.Helpers.reader_path(:page, id, URI.encode_www_form &1)))

      json conn, JSON.encode!(%{page: book.page, urls: urls})
    else
      text conn, 401, "Unauthorized access!"
    end
  end
end
