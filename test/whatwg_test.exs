defmodule WHATWGTest do
  use ExUnit.Case
  doctest WHATWG

  test "greets the world" do
    assert WHATWG.hello() == :world
  end
end
