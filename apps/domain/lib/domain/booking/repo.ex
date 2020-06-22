defmodule Booking.Repo do
  @moduledoc """
  A mock repo for Bookings
  """

  alias Booking.Item

  @items [
    Item.new("John", "Room 1"),
    Item.new("Mike", "Room 2"),
    Item.new("James", "Room 3")
  ]

  @doc """
  Return all bookings
  """
  @spec all(Booking.Item) :: [Booking.Item.t(), ...]
  def all(Item), do: @items
end
