defmodule ComicBaker.Account do
  use Ecto.Model

  schema "account", primary_key: { :email, :string, []} do
    field :password, :binary
    field :salt, :binary
  end
end
