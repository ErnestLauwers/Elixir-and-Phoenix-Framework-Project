defmodule PosterAppWeb.SessionController do
  use PosterAppWeb, :controller

  alias PosterAppWeb.Guardian
  alias PosterApp.UserContext
  alias PosterApp.UserContext.Credential

  def new(conn, _) do
    changeset = UserContext.change_credential(%Credential{})
    user_id = get_session(conn, :user_id)

    if user_id do
      conn
      |> put_flash(:info, "Already Logged In!")
      |> redirect(to: "/")
    else
      render(conn, "new.html",
        changeset: changeset,
        action: Routes.session_path(conn, :login),
        user_id: user_id
      )
    end
  end

  def login(conn, %{"credential" => %{"email" => email, "password" => password}}) do
    case Guardian.authenticate(email, password) do
      {:ok, credential, _token} ->
        user = UserContext.get_user!(credential.user_id)

        conn
        |> Guardian.Plug.sign_in(user)
        |> put_session(:user_id, credential.user_id)
        |> put_flash(:info, "Successfully logged in as #{user.first_name} #{user.last_name}!")
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
    |> delete_session(:user_id)
    |> put_flash(:info, "Successfully logged out!")
    |> redirect(to: "/")
  end
end
