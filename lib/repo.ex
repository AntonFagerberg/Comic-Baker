defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url "ecto://anton@127.0.0.1/comic_baker"
  end

  def priv do
    app_dir(:comic_baker, "priv/repo")
  end
end
