defmodule Api.Metrics.Exporter do
  @moduledoc """
  Plug the exporter in an endpoint
  """

  use Prometheus.PlugExporter
end
