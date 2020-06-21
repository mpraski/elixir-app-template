defmodule Booking.Item do
  defstruct [:id, :person, :place]

  alias Booking.Item

  @doc """
  Constructs a new Item
  """
  def new(person, place) do
    %Item{
      id: random_string(32),
      person: person,
      place: place
    }
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
