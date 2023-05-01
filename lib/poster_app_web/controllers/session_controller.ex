defmodule PosterAppWeb.SessionController do
  use PosterAppWeb, :controller

  alias PosterAppWeb.Guardian
  alias PosterApp.UserContext
  alias PosterApp.UserContext.Credential

  def new(conn, _) do
    changeset = UserContext.change_credential(%Credential{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      conn
        |> put_flash(:info, "Already Logged In!")
        |> redirect(to: "/")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end
  def login(conn, %{"credential" => %{"email" => email, "password" => password}}) do
    case Guardian.authenticate(email, password) do
      {:ok, credential, token} ->
        conn
        |> put_session(:user_id, credential.user_id)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: "/")
      {:error, :unauthored} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: "/login")
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: "/login")
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end
end
