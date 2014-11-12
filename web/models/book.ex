defmodule ComicBaker.Book do
  use Ecto.Model

  schema "book" do
    field :title, :string
    field :filename, :string
    field :email, :string
    field :created, :datetime
  end
end
