defmodule PosterApp.Repo.Migrations.UpdatePostsHashtags do
  use Ecto.Migration

  def change do
    drop constraint(:posts_hashtags, "posts_hashtags_post_id_fkey")
    drop constraint(:posts_hashtags, "posts_hashtags_hashtag_id_fkey")

    alter table(:posts_hashtags) do
      modify :post_id, references(:posts, on_delete: :delete_all)
      modify :hashtag_id, references(:hashtags, on_delete: :delete_all)
    end
  end
end
