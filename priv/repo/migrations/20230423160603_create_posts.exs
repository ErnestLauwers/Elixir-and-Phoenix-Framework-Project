defmodule PosterApp.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string, null: false
      add :text, :string, null: false
      add :user_id, references(:users)
      timestamps()
    end
  end
end
