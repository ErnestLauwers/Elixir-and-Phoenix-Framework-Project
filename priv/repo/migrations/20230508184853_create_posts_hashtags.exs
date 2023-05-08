defmodule PosterApp.Repo.Migrations.CreatePostsHashtags do
  use Ecto.Migration

  def change do
    create table(:posts_hashtags) do
      add :post_id, references(:posts)
      add :hashtag_id, references(:hashtags)
    end

    create unique_index(:posts_hashtags, [:post_id, :hashtag_id])
  end
end
