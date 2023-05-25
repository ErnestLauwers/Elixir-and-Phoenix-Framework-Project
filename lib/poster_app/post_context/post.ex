defmodule PosterApp.PostContext.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias PosterApp.UserContext.User
  alias PosterApp.PostContext.Hashtag
  alias PosterApp.PostContext.Comment

  schema "posts" do
    field :text, :string
    field :title, :string
    field :likes, :integer, default: 0
    field :liked_by, {:array, :integer}, default: []
    belongs_to :user, User
    many_to_many :hashtags, Hashtag, join_through: "posts_hashtags", on_delete: :delete_all
    has_many :comments, Comment
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :text, :user_id, :likes, :liked_by])
    |> validate_required([:title, :text, :user_id])
    |> cast_assoc(:comments)
  end
end
