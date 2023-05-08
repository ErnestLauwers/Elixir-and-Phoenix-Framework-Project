defmodule PosterApp.PostContext.Hashtag do
  use Ecto.Schema
  import Ecto.Changeset
  alias PosterApp.PostContext.Post

  schema "hashtags" do
    field :name, :string
    many_to_many :posts, Post, join_through: "posts_hashtags"
  end

  @doc false
  def changeset(hashtag, attrs) do
    hashtag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_assoc(:posts)
  end
end
