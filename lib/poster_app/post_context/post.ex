defmodule PosterApp.PostContext.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias PosterApp.UserContext.User

  schema "posts" do
    field :text, :string
    field :title, :string
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :text])
    |> validate_required([:title, :text])
  end
end
