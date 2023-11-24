defmodule ElixirCrud.Repo do
  use Ecto.Repo,
    otp_app: :elixir_crud,
    adapter: Ecto.Adapters.Postgres
end
