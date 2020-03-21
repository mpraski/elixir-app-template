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

config :domain, ecto_repos: [Domain.Repo]

# Configure your database
config :domain, Domain.Repo,
  username: "psa_user",
  password: "qwerty123",
  database: "psa_db",
  hostname: "database",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
