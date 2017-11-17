# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :takso,
  ecto_repos: [Takso.Repo]

# Configures the endpoint
config :takso, Takso.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZaYYFo4d/K+CiNRnG16/hYHLGr6E2URtlukvvCz6yfHnA40Y6aDr2mu739MtA+Cl",
  render_errors: [view: Takso.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Takso.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :canary, unauthorized_handler: {Takso.SessionController, :unauthorized}

config :guardian, Guardian,
  issuer: "Takso",
  ttl: {30, :days},
  allowed_drift: 2000,
  secret_key: "iC2u7pP33qV/0wqo2nJV7PLZM2730DFifWkM2zYfbIEkmVPf+lsrXoJH6I+PXNsc",
  serializer: Takso.GuardianSerializer