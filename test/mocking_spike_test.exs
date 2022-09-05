defmodule MockingSpikeTest do
  use ExUnit.Case
  use MockTest

  mock(MockingSpike, Collaborator: CollaboratorMock)

  test "foo" do
    expect(CollaboratorMock, :fun, fn -> true end)
    assert MockingSpike.hello() == true
  end

  test "foo2" do
    expect(CollaboratorMock, :fun2, fn -> "Hi" end)
    assert MockingSpike.hello2() == "Hi"
  end
end
