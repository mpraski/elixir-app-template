defmodule Api.BookingController do
  @moduledoc """
  A controller managing the Booking resource
  """

  use Api, :controller

  alias Api.Metrics.ViewInstrumenter

  def index(conn, _params) do
    with items <- Booking.list_items(),
         :ok <- ViewInstrumenter.view(:bookings) do
      render(conn, "index.json", items: items)
    end
  end
end
