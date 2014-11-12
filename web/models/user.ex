defmodule ComicBaker.User do
  use Ecto.Model

  schema "users", primary_key: { :email, :string, []} do
    field :password, :binary
    field :salt, :binary
  end
end
