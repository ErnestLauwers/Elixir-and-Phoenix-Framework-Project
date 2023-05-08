defmodule PosterAppWeb.UserController do
  use PosterAppWeb, :controller

  alias PosterAppWeb.Guardian
  alias PosterApp.UserContext
  alias PosterApp.UserContext.User

  def new(conn, _parameters) do
    changeset = UserContext.change_user(%User{})
    render(conn, "new.html", changeset: changeset, user_id: nil)
  end

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User #{user.first_name} #{user.last_name} created successfully.")
        |> Guardian.Plug.sign_in(user)
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset.errors)
        render(conn, "new.html", changeset: changeset, user_id: nil)
    end
  end

  def index(conn, _params) do
    users = UserContext.list_users()
    credential = Guardian.Plug.current_resource(conn);
    user_id = credential.user_id;
    render(conn, "index.html", users: users, user_id: user_id)
  end

  def show(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    credential = Guardian.Plug.current_resource(conn);
    user_id = credential.user_id;
    render(conn, "show.html", user: user, user_id: user_id)
  end

  def edit(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user_id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    case UserContext.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => id}) do
    user = UserContext.get_user!(id)
    credential = UserContext.get_credential!(id)

    {:ok, _credential} = UserContext.delete_credential(credential)
    {:ok, _user} = UserContext.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
