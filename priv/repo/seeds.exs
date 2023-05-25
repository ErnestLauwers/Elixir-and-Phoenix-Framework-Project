# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PosterApp.Repo.insert!(%PosterApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias PosterApp.Repo

# Delete all records from each table
Repo.delete_all(PosterApp.UserContext.Credential)
Repo.delete_all(PosterApp.PostContext.Hashtag)
Repo.delete_all(PosterApp.PostContext.Post)
Repo.delete_all(PosterApp.UserContext.User)

# Commit the changes
Repo.transaction(fn ->
  Repo.delete_all(PosterApp.UserContext.Credential)
  Repo.delete_all(PosterApp.PostContext.Hashtag)
  Repo.delete_all(PosterApp.PostContext.Post)
  Repo.delete_all(PosterApp.UserContext.User)
end)

{:ok, user1} =
  PosterApp.UserContext.create_user(%{
    "first_name" => "Ernest",
    "last_name" => "Lauwers",
    "date_of_birth" => DateTime.utc_now(),
    "role" => "user"
  })

{:ok, user2} =
  PosterApp.UserContext.create_user(%{
    "first_name" => "Igor",
    "last_name" => "Stefanovic",
    "date_of_birth" => DateTime.utc_now(),
    "role" => "user"
  })

{:ok, admin} =
  PosterApp.UserContext.create_user(%{
    "first_name" => "Admin",
    "last_name" => "Admin",
    "date_of_birth" => DateTime.utc_now(),
    "role" => "admin"
  })

# Create credentials for user1
{:ok, credential1} =
  PosterApp.UserContext.create_credential(%{
    "email" => "user1@gmail.com",
    "hashed_password" => "user",
    "user_id" => user1.id
  })

# Create credentials for user2
{:ok, credential2} =
  PosterApp.UserContext.create_credential(%{
    "email" => "user2@gmail.com",
    "hashed_password" => "user",
    "user_id" => user2.id
  })

# Create credentials for admin
{:ok, admin_credential} =
  PosterApp.UserContext.create_credential(%{
    "email" => "admin@gmail.com",
    "hashed_password" => "admin",
    "user_id" => admin.id
  })

{:ok, technology} =
  PosterApp.PostContext.create_hashtag(%{
    "name" => "technology"
  })

{:ok, programming} =
  PosterApp.PostContext.create_hashtag(%{
    "name" => "programming"
  })

{:ok, computer} =
  PosterApp.PostContext.create_hashtag(%{
    "name" => "computer"
  })

Repo.transaction(fn ->
  PosterApp.Repo.insert!(%PosterApp.PostContext.Post{
    title: "First Post",
    text: "This is the first post.",
    user_id: user1.id,
    hashtags: [technology, programming]
  })

  PosterApp.Repo.insert!(%PosterApp.PostContext.Post{
    title: "Second Post",
    text: "This is the second post.",
    user_id: user1.id,
    hashtags: []
  })

  PosterApp.Repo.insert!(%PosterApp.PostContext.Post{
    title: "Third Post",
    text: "This is the third post.",
    user_id: user2.id,
    hashtags: [technology, computer]
  })

  PosterApp.Repo.insert!(%PosterApp.PostContext.Post{
    title: "Fourth Post",
    text: "This is the fourth post.",
    user_id: user2.id,
    hashtags: [technology, programming, computer]
  })

  PosterApp.Repo.insert!(%PosterApp.PostContext.Post{
    title: "Admin Post",
    text: "This post is created by an admin.",
    user_id: admin.id,
    hashtags: [programming]
  })
end)
