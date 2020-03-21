defmodule Gateway.Middleware.Token do
  @moduledoc """
  Oauth2 token
  """

  @expiry_delta 10

  alias __MODULE__

  defstruct(
    type: "",
    access: "",
    refresh: "",
    expiry: nil
  )

  def new(type, opts \\ []) when type in ~w(basic bearer mac) do
    %Token{
      type: type,
      access: opts |> Keyword.get(:access, ""),
      refresh: opts |> Keyword.get(:refresh, ""),
      expiry: opts |> Keyword.get(:expiry)
    }
  end

  def with_access(token, access) do
    %Token{token | access: access || ""}
  end

  def with_refresh(token, refresh) do
    %Token{token | refresh: refresh || ""}
  end

  def with_expiry(token, expiry) do
    %Token{token | expiry: expiry || DateTime.utc_now()}
  end

  def auth_header(%Token{type: t, access: a}) do
    {"Authorization", token_type(t) <> " " <> a}
  end

  def valid?(%Token{access: nil}), do: false

  def valid?(%Token{expiry: e}), do: !expired?(e)

  # Private

  defp expired?(nil), do: false

  defp expired?(expiry) do
    result =
      expiry
      |> DateTime.add(-@expiry_delta)
      |> DateTime.compare(DateTime.utc_now())

    result == :lt
  end

  defp token_type("basic"), do: "Basic"
  defp token_type("bearer"), do: "Bearer"
  defp token_type("mac"), do: "MAC"
end
