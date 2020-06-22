defmodule Domain.Repo do
  @moduledoc """
  Our Ecto Repo
  """

  use Ecto.Repo,
    otp_app: :domain,
    adapter: Ecto.Adapters.MyXQL
end
