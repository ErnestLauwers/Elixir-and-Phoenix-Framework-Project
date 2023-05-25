defmodule PosterAppWeb.PageController do
  use PosterAppWeb, :controller

  def index(conn, _params) do
    credential = Guardian.Plug.current_resource(conn);
    if credential == nil do
      user_id = nil
      render(conn, "index.html", role: "everyone", user_id: user_id)
    else
      user_id = credential.user_id
      render(conn, "index.html", role: "everyone", user_id: user_id)
    end
  end

  def user_index(conn, _params) do
    credential = Guardian.Plug.current_resource(conn);
    if credential == nil do
      user_id = nil
      render(conn, "index.html", role: "users", user_id: user_id)
    else
      user_id = credential.user_id
      render(conn, "index.html", role: "users", user_id: user_id)
    end
  end

  def admin_index(conn, _params) do
    render(conn, "index.html", role: "admins")
  end
end
