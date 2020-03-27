defmodule Api.BookingView do
  use Api, :view

  def render("index.json", %{items: items}) do
    items |> Enum.map(&Map.from_struct/1)
  end
end
