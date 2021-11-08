defmodule Ever.Repo do
  use Ecto.Repo,
    otp_app: :ever,
    adapter: Ecto.Adapters.Postgres
end
