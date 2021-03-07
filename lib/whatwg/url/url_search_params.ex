defmodule WHATWG.URL.URLSearchParams do
  @moduledoc """
  Functions to work with `URLSearchParams`.

  See [URL Standard - URLSearchParams class](https://url.spec.whatwg.org/#interface-urlsearchparams).
  """

  alias WHATWG.URL.WwwFormUrlencoded

  @doc """
  Gets the value of the first pair whose name is `name`.

  ### Examples

      iex> get([], "a")
      nil

      iex> get([{"a", "1"}, {"b", "2"}, {"a", "3"}], "a")
      "1"

  """
  def get(list, name) when is_list(list) and is_binary(name) do
    Enum.find_value(list, nil, fn
      {^name, value} -> value
      _ -> false
    end)
  end

  @doc """
  Gets the values of all pairs whose name is `name`.

  ### Examples

      iex> get_all([], "a")
      []

      iex> get_all([{"a", "1"}, {"b", "2"}, {"a", "3"}], "a")
      ["1", "3"]
  """
  def get_all(list, name) when is_list(list) and is_binary(name) do
    list
    |> Enum.reduce([], fn
      {^name, value}, acc -> [value | acc]
      {_, _}, acc -> acc
    end)
    |> Enum.reverse()
  end

  @doc """
  Appends a new name-value pair.

  Note that it becomes slower as the list grows in size. You may use `prepend/3` and `List.reverse`



  ### Examples

      iex> append([], "a", "1")
      [{"a", "1"}]

      iex> append([{"a", "1"}], "a", "2")
      [{"a", "1"}, {"a", "2"}]
  """
  def append(list, name, value) when is_list(list) and is_binary(name) and is_binary(value),
    do: list ++ [{name, value}]

  @doc """
  Prepends a new name-value pair.

  This method is not defined in the specificiation.

  ### Examples

      iex> prepend([], "a", "1")
      [{"a", "1"}]

      iex> prepend([{"a", "1"}], "a", "2")
      [{"a", "2"}, {"a", "1"}]
  """
  def prepend(list, name, value) when is_list(list) and is_binary(name) and is_binary(value),
    do: [{name, value} | list]

  @doc """
  Returns a list of elements in `list` in reverse order.
  """
  defdelegate reverse(list), to: Enum

  @doc """
  Sets the value for the name.

  1. If the list contains any name-value pairs whose name is `name`, then set the value of the first such name-value pair to `value` and remove the others.
  1. Otherwise, append a new name-value pair whose name is `name` and value is `value`, to the list.

  ### Examples

      iex> set([], "a", "1")
      [{"a", "1"}]

      iex> set([{"a", "1"}, {"b", "2"}, {"a", "3"}], "a", "4")
      [{"a", "4"}, {"b", "2"}]
  """
  def set(list, name, value) when is_list(list) and is_binary(name) and is_binary(value) do
    case Enum.reduce(list, {[], false}, fn
           {^name, _}, {acc, false} -> {[{name, value} | acc], true}
           {^name, _}, {acc, true} -> {acc, true}
           {n, v}, {acc, placed} -> {[{n, v} | acc], placed}
         end) do
      {list, true} -> list
      {list, false} -> [{name, value} | list]
    end
    |> Enum.reverse()
  end

  @doc """
  Checks if the list contains a name-value pair whose name is `name`.

  ### Examples

      iex> has?([], "foo")
      false

      iex> has?([{"foo", "bar"}], "foo")
      true
  """
  def has?(list, name) when is_list(list) and is_binary(name) do
    Enum.any?(list, fn
      {^name, _} -> true
      _ -> false
    end)
  end

  @doc """
  Sorts name-value pairs by their names.

  ### Examples

      iex> sort([])
      []

      iex> sort([{"b", "1"}, {"a", "2"}, {"a", "1"}])
      [{"a", "2"}, {"a", "1"}, {"b", "1"}]
  """
  def sort(list) when is_list(list) do
    Enum.sort_by(list, fn {k, _} -> k end)
  end

  def parse(string) when is_binary(string), do: WwwFormUrlencoded.parse(string)

  @doc """

  ### Examples

      iex> serialize([])
      ""

      iex> serialize([{"foo", "bar"}])
      "foo=bar"

      iex> serialize([{"foo", "bar"}, {"foo", " baz "}])
      "foo=bar&foo=+baz+"
  """
  def serialize(list, to_str \\ false) when is_list(list),
    do: WwwFormUrlencoded.serialize(list, to_str)
end
