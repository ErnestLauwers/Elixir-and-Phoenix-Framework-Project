defmodule PosterAppWeb.HashtagController do
  use PosterAppWeb, :controller

  alias PosterApp.PostContext
  alias PosterApp.PostContext.Hashtag

  def index(conn, _params) do
    changeset = PostContext.change_hashtag(%Hashtag{})
    credential = Guardian.Plug.current_resource(conn)
    user_id = credential.user_id

    render(conn, "index.html",
      changeset: changeset,
      action: Routes.hashtag_path(conn, :show),
      user_id: user_id
    )
  end

  def show(conn, %{"hashtag" => %{"name" => name}}) do
    posts = PostContext.get_posts_with_hashtag(name)
    credential = Guardian.Plug.current_resource(conn)
    user_id = credential.user_id
    render(conn, "show.html", posts: posts, user_id: user_id)
  end
end
