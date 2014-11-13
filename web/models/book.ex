defmodule ComicBaker.Book do
  use Ecto.Model
  
  import Ecto.Query

  schema "book" do
    field :title, :string
    field :filename, :string
    field :email, :string
    field :created, :datetime
  end
  
  def all(email) do
    Repo.all from b in ComicBaker.Book, where: b.email == ^email
  end
  
  def owner(id, email) do
    Repo.all(from b in ComicBaker.Book, where: b.email == ^email and b.id == ^id) != []
  end
end
