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
{:ok, _cs} = Auth.UserContext.create_user(%{
  "first_name" => "John",
  "last_name" => "Doe",
  "birthdate" => DateTime.utc_now(),
  "role" => "user",
  "credential" => %{
    "email" => "johndoe@gmail.com",
    "password" => "t"
  }
})

{:ok, _cs} = Auth.UserContext.create_user(%{
  "first_name" => "Mark",
  "last_name" => "Johnson",
  "birthdate" => DateTime.utc_now(),
  "role" => "admin",
  "credential" => %{
    "email" => "markjohnson@gmail.com",
    "password" => "t"
  }
})
