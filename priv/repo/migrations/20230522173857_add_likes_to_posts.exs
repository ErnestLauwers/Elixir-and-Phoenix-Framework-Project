defmodule MyApp.Repo.Migrations.AddLikesToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :likes, :integer, default: 0
    end
  end
end
