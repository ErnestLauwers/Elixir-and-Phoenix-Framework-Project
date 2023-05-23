defmodule PosterAppWeb.Plugs.AuthorizationPlug do
  import Plug.Conn
  alias PosterApp.UserContext
  alias Phoenix.Controller

  def init(options), do: options

  def call(conn, roles) do
    credential = Guardian.Plug.current_resource(conn)
    user = UserContext.get_user!(credential.user_id)

    conn
    |> grant_access(user.role in roles)
  end

  def grant_access(conn, true), do: conn

  def grant_access(conn, false) do
    conn
    |> Controller.put_flash(:error, "Unauthorized access")
    |> Controller.redirect(to: "/")
    |> halt
  end
end
