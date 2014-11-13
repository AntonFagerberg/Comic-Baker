defmodule Repo.Migrations.Book do
  use Ecto.Migration

  def up do
    "ALTER TABLE book ADD page integer NOT NULL DEFAULT 0;"
  end

  def down do
    "ALTER TABLE book DROP page;"
  end
end
