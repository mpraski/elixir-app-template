defmodule Api.Metrics.Exporter do
  @moduledoc """
  Module defining the prometheus metrics
  to be exported
  """

  use Prometheus.PlugExporter
end
