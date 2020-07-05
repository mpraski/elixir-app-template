defmodule Api.Metrics.ViewInstrumenter do
  @moduledoc """
  An example metric
  """

  use Prometheus.Metric

  @metric :views_total
  @labels [:view]
  @description "Views Count"

  def setup do
    Counter.declare(
      name: @metric,
      help: @description,
      labels: @labels
    )
  end

  def view(view) do
    Counter.inc(
      name: @metric,
      labels: [view]
    )
  end
end
