defmodule PosterApp.Repo.Migrations.AddFollowingToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :following, {:array, :integer}, default: []
    end
  end
end
