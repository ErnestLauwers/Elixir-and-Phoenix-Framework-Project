defmodule PosterApp.UserContext do
  import Ecto.Query, warn: false

  alias __MODULE__.User
  alias __MODULE__.Credential
  alias PosterApp.Repo

  @doc "Returns a user changeset"
  def change_user(%User{} = user) do
    user |> User.changeset(%{})
  end

  def change_credential(%Credential{} = credential) do
    credential |> Credential.changeset(%{})
  end

  @doc "Creates a user based on some external attributes"
  def create_user(attributes) do
    %User{}
    |> User.changeset(attributes)
    |> Repo.insert()
  end

  def create_credential(attributes) do
    %Credential{}
    |> Credential.changeset(attributes)
    |> Repo.insert()
  end

  @doc "Returns a specific user or raises an error"
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  @spec get_credential!(any) :: any
  def get_credential!(id), do: Repo.get_by(Credential, user_id: id)

  def get_credential(id), do: Repo.get_by(Credential, user_id: id)

  def get_credential_by_email(email) do
    Credential
    |> where(email: ^email)
    |> Repo.one()
  end

  @doc "Returns all users in the system"
  def list_users do
    query =
      from(u in User,
        order_by: [asc: u.first_name]
      )

    Repo.all(query)
  end

  @doc "Update an existing user with external attributes"
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc "Delete a user"
  def delete_user(%User{} = user), do: Repo.delete(user)

  def delete_credential(%Credential{} = credential), do: Repo.delete(credential)

  def follow(%User{} = user, user_id) do
    following = user.following ++ [user_id]
    updated_user = Ecto.Changeset.change(user, %{following: following})
    Repo.update(updated_user)
  end

  def unfollow(%User{} = user, id) do
    following = user.following |> List.delete(id)
    updated_user = Ecto.Changeset.change(user, %{following: following})
    Repo.update(updated_user)
  end
end
