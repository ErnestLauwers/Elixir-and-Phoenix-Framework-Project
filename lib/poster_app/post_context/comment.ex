defmodule PosterApp.PostContext.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias PosterApp.PostContext.Post
  alias PosterApp.UserContext.User

  schema "comments" do
    field :text, :string
    belongs_to :post, Post
    belongs_to :user, User
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text, :post_id, :user_id])
    |> validate_required([:text, :post_id, :user_id])
  end
end
