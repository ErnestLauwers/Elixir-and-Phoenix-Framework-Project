defmodule PosterApp.PostContext do
  alias __MODULE__.Post
  alias __MODULE__.Hashtag
  alias PosterApp.Repo
  import Ecto.Query
  alias PosterApp.PostContext.Comment

  def list_posts do
    query =
      from(p in Post,
        order_by: [desc: p.title],
        preload: [:user, :hashtags]
      )

    Repo.all(query)
  end

  def list_comments, do: Repo.all(Comment) |> Repo.preload(:post) |> Repo.preload(:user)

  def list_hashtags, do: Repo.all(Hashtag) |> Repo.preload(:posts)

  def get_post!(id) do
    Repo.get!(Post, id) |> Repo.preload([:user, :hashtags])
  end

  def get_comment!(id) do
    Repo.get!(Comment, id) |> Repo.preload(:post) |> Repo.preload(:user)
  end

  def change_post(%Post{} = post) do
    post |> Post.changeset(%{})
  end

  def change_comment(%Comment{} = comment) do
    comment |> Comment.changeset(%{})
  end

  def change_hashtag(%Hashtag{} = hashtag) do
    hashtag |> Hashtag.changeset(%{})
  end

  def create_post(attributes \\ %{}) do
    %Post{}
    |> Post.changeset(attributes)
    |> Ecto.Changeset.put_assoc(:hashtags, posts_hashtags(attributes))
    |> Repo.insert()
  end

  def create_hashtag(attributes) do
    %Hashtag{}
    |> Hashtag.changeset(attributes)
    |> Repo.insert()
  end

  def get_posts_with_hashtag(name) do
    from(post in Post,
      join: hashtag in assoc(post, :hashtags),
      where: hashtag.name == ^name,
      preload: [:hashtags]
    )
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def get_comments_from_post(post_id) do
    from(comment in Comment,
      where: comment.post_id == ^post_id,
      preload: [:post, :user]
    )
    |> Repo.all()
  end

  defp parse_hashtags(nil), do: []

  defp parse_hashtags(hashtags) do
    for hashtag <- String.split(hashtags, ","),
        hashtag = hashtag |> String.trim() |> String.downcase(),
        hashtag != "",
        do: %{name: hashtag}
  end

  def get_post_with_hashtags!(id), do: Post |> preload(:hashtags) |> Repo.get!(id)

  defp posts_hashtags(attributes) do
    hashtags = parse_hashtags(attributes["hashtags"])
    Repo.insert_all(Hashtag, hashtags, on_conflict: :nothing)
    hashtag_names = for h <- hashtags, do: h.name
    Repo.all(from(h in Hashtag, where: h.name in ^hashtag_names))
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post), do: Repo.delete(post)

  def delete_comment(%Comment{} = comment), do: Repo.delete(comment)

  def increase_likes(%Post{} = post, user_id) do
    liked_by = post.liked_by ++ [user_id]
    updated_post = Ecto.Changeset.change(post, %{likes: post.likes + 1, liked_by: liked_by})

    Repo.update(updated_post)
  end

  def decrease_likes(%Post{} = post, user_id) do
    liked_by = post.liked_by |> List.delete(user_id)
    updated_post = Ecto.Changeset.change(post, %{likes: post.likes - 1, liked_by: liked_by})
    Repo.update(updated_post)
  end

  def create_comment(attributes \\ %{}) do
    %Comment{}
    |> Comment.changeset(attributes)
    |> Repo.insert()
  end
end
