defmodule PosterApp.PostContext do
  alias __MODULE__.Post
  alias __MODULE__.Hashtag
  alias PosterApp.Repo
  import Ecto.Query

  def list_posts, do: Repo.all(Post) |> Repo.preload(:user) |> Repo.preload(:hashtags)

  def list_hashtags, do: Repo.all(Hashtag) |> Repo.preload(:posts)

  def get_post!(id), do: Repo.get!(Post, id)

  def change_post(%Post{} = post) do
    post |> Post.changeset(%{})
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
    Repo.all(from h in Hashtag, where: h.name in ^hashtag_names)
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post), do: Repo.delete(post)
end
