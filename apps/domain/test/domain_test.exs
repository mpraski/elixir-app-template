defmodule DomainTest do
  use ExUnit.Case
  doctest Domain

  test "greets the world" do
    assert Domain.hello() == :world
  end
end
