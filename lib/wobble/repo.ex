defmodule Wobble.Repo do
  use Ecto.Repo,
    otp_app: :wobble,
    adapter: Ecto.Adapters.Postgres
end
