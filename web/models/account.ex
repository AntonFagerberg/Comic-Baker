defmodule ComicBaker.Account do
  use Ecto.Model
  import Ecto.Query
  
  schema "account", primary_key: { :email, :string, []} do
    field :password, :binary
    field :salt, :binary
  end
  
  def get(email) do
    Enum.at Repo.all(
      from b in ComicBaker.Account,
      where: b.email == ^email,
      limit: 1
    ), 0
  end
end
