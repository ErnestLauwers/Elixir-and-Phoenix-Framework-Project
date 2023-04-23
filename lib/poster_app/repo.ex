defmodule PosterApp.Repo do
  use Ecto.Repo,
    otp_app: :poster_app,
    adapter: Ecto.Adapters.Postgres
end
