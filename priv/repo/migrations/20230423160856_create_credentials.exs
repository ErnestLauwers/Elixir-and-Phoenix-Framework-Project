defmodule PosterApp.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :email, :string, null: false
      add :password, :string, null: false
      add :user_id, references(:users)
    end
  end
end
