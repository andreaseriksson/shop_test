# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :shop_test,
  ecto_repos: [ShopTest.Repo]

# Configures the endpoint
config :shop_test, ShopTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qYFmsj/902Xfq2doA2ajRoJgBhYjnbfPZMmIfvwjYlYUJL0bZaXB/2G2hAAOWKE0",
  render_errors: [view: ShopTestWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ShopTest.PubSub,
  live_view: [signing_salt: "9mbp++8x"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :stripity_stripe, api_key: System.get_env("STRIPE_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
