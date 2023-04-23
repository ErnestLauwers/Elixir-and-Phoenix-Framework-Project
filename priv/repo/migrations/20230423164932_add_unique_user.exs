defmodule PosterApp.Repo.Migrations.AddUniqueUser do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:first_name, :last_name, :date_of_birth],
             name: :unique_users_index
    )
  end
end
