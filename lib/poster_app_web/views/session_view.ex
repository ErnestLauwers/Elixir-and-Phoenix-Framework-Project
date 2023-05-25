defmodule PosterAppWeb.SessionView do
  use PosterAppWeb, :view

  def render("token.json", %{access_token: access_token}) do
    %{access_token: access_token}
  end
end
