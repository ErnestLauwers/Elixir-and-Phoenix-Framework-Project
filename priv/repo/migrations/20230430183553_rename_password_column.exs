defmodule PosterApp.Repo.Migrations.RenamePasswordColumn do
  use Ecto.Migration

  def change do
    rename table(:credentials), :password, to: :hashed_password
  end
end
