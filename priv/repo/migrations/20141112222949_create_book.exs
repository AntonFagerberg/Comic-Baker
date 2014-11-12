defmodule Repo.Migrations.CreateBook do
  use Ecto.Migration

  def up do
    "
    CREATE TABLE book(
    	id serial NOT NULL primary key,
    	title varchar(255) NOT NULL,
    	filename varchar(255) NOT NULL,
    	email varchar(255) NOT NULL REFERENCES users (email),
    	created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    "
  end

  def down do
    "
    DROP TABLE book;
    "
  end
end
