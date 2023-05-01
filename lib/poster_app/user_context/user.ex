defmodule PosterApp.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PosterApp.PostContext.Post
  alias PosterApp.UserContext.Credential

  schema "users" do
    field :date_of_birth, :date
    field :first_name, :string
    field :last_name, :string
    field :role, :string
    has_many :posts, Post
    has_one :credentials, Credential
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :date_of_birth, :role])
    |> validate_required([:first_name, :last_name, :date_of_birth, :role])
    |> cast_assoc(:credentials)
    |> cast_assoc(:posts)
    |> unique_constraint(:date_of_birth,
      name: :unique_users_index,
      message:
        "Wow that's coincidence! " <>
          "Another person with the same first name and last name was born at this day. " <>
          "Oh gosh, our system can't deal with this. " <>
          "Contact our administrators or change your name. "
    )
  end
end
