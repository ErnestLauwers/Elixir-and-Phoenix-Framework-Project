defmodule PosterApp.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PosterApp.PostContext.Post
  alias PosterApp.UserContext.Credential

  @acceptable_roles ["admin", "user"]

  schema "users" do
    field :date_of_birth, :date
    field :first_name, :string
    field :last_name, :string
    field :role, :string
    field :following, {:array, :integer}, default: []
    has_many :posts, Post
    has_one :credentials, Credential
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :date_of_birth, :role, :following])
    |> validate_required([:first_name, :last_name, :date_of_birth, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> cast_assoc(:credentials)
    |> cast_assoc(:posts)
    |> unique_constraint(:date_of_birth,
      name: :unique_users_index,
      message: "There is already a user with this name and birthdate..."
    )
  end
end
