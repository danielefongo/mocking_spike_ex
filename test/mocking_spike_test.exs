defmodule MockingSpikeTest do
  use ExUnit.Case
  doctest MockingSpike

  import Hammox
  import Rewire
  setup :verify_on_exit!

  defmock(CollaboratorMock, for: Collaborator.Behaviour)
  rewire(MockingSpike, Collaborator: CollaboratorMock)

  test "foo" do
    expect(CollaboratorMock, :fun, fn -> true end)
    assert MockingSpike.hello() == true
  end

  test "foo2" do
    expect(CollaboratorMock, :fun2, fn -> "Hi" end)
    assert MockingSpike.hello2() == "Hi"
  end
end
