defmodule Api.Metrics.Setup do
  @moduledoc """
  Setup all metrics
  """

  def setup do
    Api.Metrics.PhoenixInstrumenter.setup()
    Api.Metrics.PipelineInstrumenter.setup()
    Api.Metrics.ViewInstrumenter.setup()
    Api.Metrics.Exporter.setup()
  end
end
