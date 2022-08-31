defmodule MockingSpikeTest do
  use ExUnit.Case
  doctest MockingSpike

  test "greets the world" do
    assert MockingSpike.hello() == :world
  end
end
