defmodule PosterAppWeb.Guardian do
  use Guardian, otp_app: :poster_app

  alias PosterApp.UserContext

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case UserContext.get_credential!(id) do
      nil -> {:error, :resource_not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def authenticate(email, password) do
    case UserContext.get_credential_by_email(email) do
      nil ->
        {:error, :unauthored}

      credential ->
        IO.inspect(credential)

        case validate_password(password, credential.hashed_password) do
          true -> create_token(credential)
          false -> {:error, :unauthorized}
        end
    end
  end

  defp validate_password(password, hashed_password) do
    Pbkdf2.verify_pass(password, hashed_password)
  end

  defp create_token(credential) do
    {:ok, token, _claims} = encode_and_sign(credential)
    {:ok, credential, token}
  end
end
