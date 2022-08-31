defmodule MockTest do
  defmacro mock(module, bindings) do
    Enum.map(bindings, fn {collaborator, mock} ->
      quote do
        defmock(unquote(mock), for: unquote(collaborator).Behaviour)
        rewire(unquote(module), [{unquote(collaborator), unquote(mock)}])
      end
    end)
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
