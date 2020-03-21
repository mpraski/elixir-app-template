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

config :api,
  generators: [context_app: false]

# Configures the endpoint
config :api, Api.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SkhLSEBG7hcIRVGRQMhMAHYtlVwbHH7LHlWTUUCj6mIhlXgxkVbW2YlSnRutaTzq",
  render_errors: [view: Api.ErrorView, accepts: ~w(json)]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :prometheus,
  mnesia_collector_metrics: [],
  vm_memory_collector_metrics: [],
  vm_statistics_collector_metrics: [],
  vm_system_info_collector_metrics: []
