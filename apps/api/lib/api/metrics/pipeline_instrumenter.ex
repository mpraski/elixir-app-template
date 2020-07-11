defmodule Api.Metrics.PipelineInstrumenter do
  @moduledoc """
  Pipeline instrumenter
  """

  use Prometheus.PlugPipelineInstrumenter

  def label_value(:request_path, conn) do
    conn.request_path
  end
end
