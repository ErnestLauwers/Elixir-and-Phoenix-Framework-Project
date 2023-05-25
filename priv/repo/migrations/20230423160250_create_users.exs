defmodule PosterApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :date_of_birth, :date, null: false
      add :role, :string, null: false
    end
  end
end
