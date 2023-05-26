defmodule PosterAppWeb.PostController do
  use PosterAppWeb, :controller

  alias PosterApp.UserContext
  alias PosterApp.PostContext
  alias PosterApp.PostContext.Post
  alias PosterApp.PostContext.Comment

  def index(conn, _params) do
    posts = PostContext.list_posts()
    credential = Guardian.Plug.current_resource(conn)
    user_id = credential.user_id
    user = UserContext.get_user!(user_id)
    sorted_posts = Enum.sort_by(posts, &sort_by_following(&1, user.following))
    render(conn, "index.html", posts: sorted_posts, user_id: user_id, user: user)
  end

  defp sort_by_following(post, following_list) do
    if post.user_id in following_list, do: 0, else: 1
  end

  def new(conn, _parameters) do
    changeset = PostContext.change_post(%Post{hashtags: []})
    credential = Guardian.Plug.current_resource(conn)
    user_id = credential.user_id
    render(conn, "new.html", changeset: changeset, user_id: user_id)
  end

  def create(conn, %{"post" => post_params}) do
    case PostContext.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post #{post.title} created successfully.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        credential = Guardian.Plug.current_resource(conn)
        user_id = credential.user_id
        IO.inspect(changeset.errors)
        render(conn, "new.html", changeset: changeset, user_id: user_id)
    end
  end

  def edit(conn, %{"post_id" => id}) do
    post = PostContext.get_post!(id)
    changeset = PostContext.change_post(post)
    user_id = Guardian.Plug.current_resource(conn)
    render(conn, "edit.html", post: post, changeset: changeset, user_id: user_id)
  end

  def update(conn, %{"post_id" => id, "post" => post_params}) do
    post = PostContext.get_post!(id)

    case PostContext.update_post(post, post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"post_id" => id}) do
    post = PostContext.get_post!(id)

    {:ok, _post} = PostContext.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  def delete_comment(conn, %{"post_id" => post_id, "comment_id" => comment_id}) do
    comment = PostContext.get_comment!(comment_id)

    {:ok, _comment} = PostContext.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :interact, post_id))
  end

  def interact(conn, %{"post_id" => id}) do
    post = PostContext.get_post!(id)
    credential = Guardian.Plug.current_resource(conn)
    user_id = credential.user_id
    comments_post = PostContext.get_comments_from_post(id)

    render(conn, "interact.html",
      post: post,
      user_id: user_id,
      comments_post: comments_post
    )
  end

  def increase_likes(conn, %{"post_id" => id}) do
    post = PostContext.get_post!(id)
    credential = Guardian.Plug.current_resource(conn)
    user_id = credential.user_id
    user = UserContext.get_user!(user_id)
    PostContext.increase_likes(post, user_id)
    posts = PostContext.list_posts()
    render(conn, "index.html", posts: posts, user_id: user_id, user: user)
  end

  def decrease_likes(conn, %{"post_id" => id}) do
    post = PostContext.get_post!(id)
    credential = Guardian.Plug.current_resource(conn)
    user_id = credential.user_id
    user = UserContext.get_user!(user_id)
    PostContext.decrease_likes(post, user_id)
    posts = PostContext.list_posts()
    render(conn, "index.html", posts: posts, user_id: user_id, user: user)
  end

  def add_comment(conn, %{"post_id" => id}) do
    changeset = PostContext.change_comment(%Comment{})
    post = PostContext.get_post!(id)
    credential = Guardian.Plug.current_resource(conn)
    user_id = credential.user_id
    render(conn, "add_comment.html", changeset: changeset, post: post, user_id: user_id)
  end

  def create_comment(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    case PostContext.create_comment(comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.post_path(conn, :interact, post_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        credential = Guardian.Plug.current_resource(conn)
        user_id = credential.user_id
        IO.inspect(changeset.errors)
        render(conn, "add_comment.html", changeset: changeset, user_id: user_id)
    end
  end
end
