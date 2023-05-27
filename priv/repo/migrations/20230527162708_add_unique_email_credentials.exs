defmodule PosterApp.Repo.Migrations.AddUniqueEmailCredentials do
  use Ecto.Migration

  def change do
    create unique_index(:credentials, [:email],
             name: :unique_email_index
    )
  end
end
