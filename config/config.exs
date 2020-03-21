# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# By default, the umbrella project as well as each child
# application will require this configuration file, as
# configuration and dependencies are shared in an umbrella
# project. While one could configure all applications here,
# we prefer to keep the configuration of each individual
# child application in their own app, but all other
# dependencies, regardless if they belong to one or multiple
# apps, should be configured in the umbrella to avoid confusion.
for config <- "../apps/*/config/{config,#{Mix.env()}}.exs" |> Path.expand(__DIR__) |> Path.wildcard() do
  import_config config
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
with config <- "#{Mix.env()}.exs", true <- File.exists?(config) do
  import_config config
end
