defmodule PosterApp.Repo.Migrations.AddUniqueCredentials do
  use Ecto.Migration

  def change do
    create unique_index(:credentials, [:user_id])
  end
end
