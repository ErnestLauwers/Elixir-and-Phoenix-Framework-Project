defmodule PosterApp.Repo.Migrations.AddDefaultRoleUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :role, :string, default: "user"
    end
  end
end
