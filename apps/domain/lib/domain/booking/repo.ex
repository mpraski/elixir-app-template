defmodule Booking.Repo do
  alias Booking.Item

  @items [
    Item.new("John", "Room 1"),
    Item.new("Mike", "Room 2"),
    Item.new("James", "Room 3")
  ]

  def all(Item), do: @items
end
