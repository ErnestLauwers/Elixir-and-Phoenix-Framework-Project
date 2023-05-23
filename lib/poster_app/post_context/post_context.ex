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

  def get_posts_with_hashtag(name) do
    all_posts = list_posts()
    matching_posts = []

    for post <- all_posts do
      hashtags = post.hashtags
      IO.inspect(hashtags)

      for hashtag <- hashtags do
        IO.inspect(name)

        if hashtag.name == name do
          matching_posts = [post | matching_posts]
          IO.inspect(matching_posts)
          IO.puts("kanker")
        end
      end
    end

    IO.inspect(matching_posts)
    matching_posts
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
