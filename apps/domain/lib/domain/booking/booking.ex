defmodule Booking do
  alias Booking.{Repo, Item}

  @repo Repo

  def list_items do
    @repo.all(Item)
  end
end
