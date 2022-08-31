defmodule CollaboratorBehaviour do
  @callback fun :: boolean()
end

defmodule Collaborator do
  @behaviour CollaboratorBehaviour
  @spec fun :: boolean()
  def fun, do: true
end

defmodule MockingSpike do
  @moduledoc """
  Documentation for `MockingSpike`.
  """

  @spec hello :: boolean()
  def hello do
    Collaborator.fun()
  end
end
