defmodule PosterApp.UserContext.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias PosterApp.UserContext.User

  schema "credentials" do
    field :email, :string
    field :password, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end
end
