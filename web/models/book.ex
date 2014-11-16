defmodule ComicBaker.Book do
  use Ecto.Model
  
  import Ecto.Query

  schema "book" do
    field :title, :string
    field :filename, :string
    field :email, :string
    field :created, :datetime
    field :page, :integer
  end
  
  def all(email) do
    Repo.all from b in ComicBaker.Book, where: b.email == ^email
  end
  
  def get(id, email) do
    Enum.at Repo.all(
      from b in ComicBaker.Book, 
      where: b.email == ^email and b.id == ^id,
      limit: 1
    ), 0
  end
end
