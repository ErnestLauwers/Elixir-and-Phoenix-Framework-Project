defmodule PosterApp.PostContext do
  alias __MODULE__.Post
  alias PosterApp.Repo

  def list_posts, do: Repo.all(Post) |> Repo.preload(:user)

  def get_post!(id), do: Repo.get!(Post, id)

  def change_post(%Post{} = post) do
    post |> Post.changeset(%{})
  end

  def create_post(attributes) do
    %Post{}
    |> Post.changeset(attributes)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post), do: Repo.delete(post)
end
