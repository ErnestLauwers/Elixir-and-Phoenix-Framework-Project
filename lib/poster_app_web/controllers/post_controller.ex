defmodule PosterAppWeb.PostController do
  use PosterAppWeb, :controller

  alias PosterApp.UserContext
  alias PosterApp.PostContext
  alias PosterApp.PostContext.Post

  def index(conn, _params) do
    posts = PostContext.list_posts()
    credential = Guardian.Plug.current_resource(conn)
    user_id = credential.user_id
    user = UserContext.get_user!(user_id)
    render(conn, "index.html", posts: posts, user_id: user_id, user: user)
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
end
