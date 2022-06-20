defmodule CatFinderTest do
  use ExUnit.Case
  doctest CatFinder

  test "greets the world" do
    assert CatFinder.hello() == :world
  end
end
