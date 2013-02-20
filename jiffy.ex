defmodule Jiffy do
  @moduledoc """
  This module is a wrapper for the Jiffy JSON library.

  ## Examples

    Jiffy.encode({[{foo: bar, count: 1}]})
    Jiffy.encode({[{"foo": "bar", "count": 1}]})

    Jiffy.decode("\\"foo\\": \\"bar\\", \\"count\\": 1}]})
  """

  actions = [:encode]

  lc action inlist actions do
    contents =
    quote do

      @doc "See the module doc"
      def unquote(action).(data) do
        json(unquote(action), data)
      end

      @doc "Accepts the Jiffy argument list"
      def unquote(action).(data, args) do
        json(unquote(action), data, args)
      end

    end

    Module.eval_quoted __MODULE__, contents

  end

  @doc "This is a simple wrapper around the Jiffy.decode function"
  def decode(data) do
    :jiffy.decode(data)
  end

  defp json(:encode, {data}) do
    data = Enum.map data, fn({key, value}) ->
      reformat {key, value}
    end
    :jiffy.encode({data})
  end

  defp json(:encode, {data}, args) do
    data = Enum.map data, fn({key, value}) ->
      reformat {key, value}
    end
    :jiffy.encode({data}, args)
  end

  defp reformat({key, value}) when is_atom(key) and is_atom(value) do
    {atom_to_binary(key), atom_to_binary(value)}
  end

  defp reformat({key, value}) when is_atom(key) do
    {atom_to_binary(key), value}
  end

  defp reformat({key, value}) when is_atom(value) do
    {key, atom_to_binary(value)}
  end

  defp reformat({key, value}) do
    {key, value}
  end

end
