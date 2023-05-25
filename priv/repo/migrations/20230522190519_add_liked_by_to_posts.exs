defmodule PosterApp.Repo.Migrations.AddLikedByToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add(:liked_by, {:array, :integer}, default: [])
    end
  end
end
