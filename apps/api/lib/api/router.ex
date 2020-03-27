defmodule Api.Router do
  use Api, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", Api do
    pipe_through(:api)

    resources("/bookings", BookingController, only: [:index])
  end
end
