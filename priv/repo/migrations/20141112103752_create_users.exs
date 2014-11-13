defmodule Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    "CREATE TABLE account(
      email varchar(140) primary key,
      salt bytea,
      password bytea
    )"
  end

  def down do
    "DROP TABLE account"
  end
end
