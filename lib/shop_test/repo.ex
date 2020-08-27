defmodule ShopTest.Repo do
  use Ecto.Repo,
    otp_app: :shop_test,
    adapter: Ecto.Adapters.Postgres
end
