defmodule PosterApp.UserContext.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias PosterApp.UserContext.User

  schema "credentials" do
    field :email, :string
    field :hashed_password, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :hashed_password, :user_id])
    |> validate_required([:email, :hashed_password])
    |> unique_constraint(:email,
      name: :unique_email_index,
      message: "There is already a user with this email..."
    )
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{hashed_password: hashed_password}} = changeset
       ) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(hashed_password))
  end

  defp put_password_hash(changeset), do: changeset
end
