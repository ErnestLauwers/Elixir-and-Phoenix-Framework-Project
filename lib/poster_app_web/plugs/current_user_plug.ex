defmodule PosterAppWeb.Plugs.CurrentUserPlug do
  import Plug.Conn
  import Guardian.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
      user ->
        assign(conn, :current_user, user)
    end
  end
end
