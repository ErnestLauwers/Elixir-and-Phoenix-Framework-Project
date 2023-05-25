defmodule PosterApp.Repo.Migrations.RemoveCommentIdFromPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :comment_id
    end
  end
end
