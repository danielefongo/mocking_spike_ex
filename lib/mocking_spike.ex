defmodule ConcreteBehaviour do
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [@: 1]
      require ConcreteBehaviour
      import ConcreteBehaviour

      Attributes.set(__MODULE__, [:specs], [])

      @behaviour __MODULE__.Behaviour
      @before_compile ConcreteBehaviour
    end
  end

  defmacro __before_compile__(_) do
    callbacks =
      __CALLER__.module
      |> Attributes.get([:specs])
      |> Enum.map(fn a ->
        quote do
          @callback unquote(a)
        end
      end)

    quote do
      Kernel.defmodule(Behaviour, do: {:body, [], unquote(callbacks)})
      Attributes.delete(__MODULE__, [:specs])
    end
  end

  defmacro @({:spec, _, spec_body} = val) do
    quote do
      Attributes.update(
        __MODULE__,
        [:specs],
        [],
        &(&1 ++ unquote(Macro.escape(spec_body)))
      )

      Kernel.@(unquote(val))
    end
  end

  defmacro @val do
    quote do
      Kernel.@(unquote(val))
    end
  end
end

defmodule CollaboratorBehaviour do
  @callback fun :: boolean()
end

defmodule Collaborator do
  use ConcreteBehaviour
  import ConcreteBehaviour

  @spec fun :: boolean()
  def fun, do: true

  @spec fun2 :: String.t()
  def fun2, do: "Hello"
end

defmodule MockingSpike do
  @moduledoc """
  Documentation for `MockingSpike`.
  """

  @spec hello :: boolean()
  def hello do
    Collaborator.fun()
  end

  @spec hello2 :: String.t()
  def hello2 do
    Collaborator.fun2()
  end
end
