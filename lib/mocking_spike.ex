defmodule ConcreteBehaviour do
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [@: 1]
      require ConcreteBehaviour
      import ConcreteBehaviour

      Module.put_attribute(__MODULE__, :specs, %{funs: []})

      @behaviour __MODULE__.Behaviour
      @before_compile ConcreteBehaviour
    end
  end

  defmacro __before_compile__(_) do
    callbacks =
      __CALLER__.module
      |> Module.get_attribute(:specs)
      |> Map.get(:funs)
      |> Enum.map(fn spec -> quote(do: @callback(unquote(spec))) end)

    quote do
      Kernel.defmodule(Behaviour, do: {:body, [], unquote(callbacks)})
      Module.delete_attribute(__MODULE__, :specs)
    end
  end

  defmacro @({:spec, _, spec_body} = spec) do
    quote do
      new_specs =
        __MODULE__
        |> Module.get_attribute(:specs)
        |> update_in([:funs], &(&1 ++ unquote(Macro.escape(spec_body))))

      Module.put_attribute(__MODULE__, :specs, new_specs)

      Kernel.@(unquote(spec))
    end
  end

  defmacro @spec do
    quote do
      Kernel.@(unquote(spec))
    end
  end
end

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

defmodule Collaborator do
  use ConcreteBehaviour

  @spec fun :: boolean()
  def fun, do: true

  @spec fun2 :: String.t()
  def fun2, do: "Hello"
end

defmodule MockingSpike do
  @spec hello :: boolean()
  def hello, do: Collaborator.fun()

  @spec hello2 :: String.t()
  def hello2, do: Collaborator.fun2()
end
