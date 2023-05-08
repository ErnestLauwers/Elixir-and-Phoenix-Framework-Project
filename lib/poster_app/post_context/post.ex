defmodule PosterApp.PostContext.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias PosterApp.UserContext.User
  alias PosterApp.PostContext.Hashtag

  schema "posts" do
    field :text, :string
    field :title, :string
    belongs_to :user, User
    many_to_many :hashtags, Hashtag, join_through: "posts_hashtags", on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :text, :user_id])
    |> validate_required([:title, :text, :user_id])
  end
end
