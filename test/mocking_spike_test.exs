defmodule MockTest do
  defmacro mock(module, collaborator_module, mock) do
    quote do
      defmock(unquote(mock), for: unquote(collaborator_module).Behaviour)
      rewire(unquote(module), [{unquote(collaborator_module), unquote(mock)}])
    end
  end

  defmacro __using__(_) do
    quote do
      require MockTest
      import MockTest
      import Hammox
      import Rewire
      setup :verify_on_exit!
    end
  end
end

defmodule MockingSpikeTest do
  use ExUnit.Case
  use MockTest

  mock(MockingSpike, Collaborator, CollaboratorMock)

  test "foo" do
    expect(CollaboratorMock, :fun, fn -> true end)
    assert MockingSpike.hello() == true
  end

  test "foo2" do
    expect(CollaboratorMock, :fun2, fn -> "Hi" end)
    assert MockingSpike.hello2() == "Hi"
  end
end
