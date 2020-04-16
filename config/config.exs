# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :paperhubapi,
  ecto_repos: [Paperhubapi.Repo]

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, {:awscli, "default", 30}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, {:awscli, "default", 30}, :instance_role]

# Configures the endpoint
config :paperhubapi, PaperhubapiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1clqL1PeZ9ya5Y4rWyiuPsK2SOTwISZjIMcJFm5LGHsYhRfl0fS5MjepZXB5xK+u",
  render_errors: [view: PaperhubapiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Paperhubapi.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "hSMj8sCa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
