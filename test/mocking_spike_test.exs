defmodule MockingSpikeTest do
  use ExUnit.Case
  doctest MockingSpike

  import Hammox
  import Rewire
  setup :verify_on_exit!

  defmock(CollaboratorMock, for: CollaboratorBehaviour)
  rewire(MockingSpike, Collaborator: CollaboratorMock)

  test "foo" do
    expect(CollaboratorMock, :fun, fn -> true end)
    assert MockingSpike.hello() == true
  end
end
