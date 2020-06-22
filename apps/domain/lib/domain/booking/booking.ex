defmodule Booking do
  @moduledoc """
  Module definition operations on Bookings
  """

  alias Booking.{Item, Repo}

  @repo Repo

  @doc """
  List all items in the repo
  """
  @spec list_items :: [Booking.Item.t(), ...]
  def list_items do
    @repo.all(Item)
  end
end
