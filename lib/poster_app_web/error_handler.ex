defmodule PosterAppWeb.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(type)})
    conn
      |> put_resp_content_type("text/plain")
      |> send_resp(401, body)
      |> halt()
  end
end
