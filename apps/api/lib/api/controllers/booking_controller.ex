defmodule Api.BookingController do
  use Api, :controller

  def index(conn, _params) do
    items = Booking.list_items()
    render(conn, "index.json", items: items)
  end
end
