defmodule Paperhubapi.Repo do
  use Ecto.Repo,
    otp_app: :paperhubapi,
    adapter: Ecto.Adapters.Postgres
end
