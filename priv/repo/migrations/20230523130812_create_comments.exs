defmodule PosterApp.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :string, null: false
      add :post_id, references(:posts, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
