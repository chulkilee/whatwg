defmodule WHATWG.URL.WwwFormUrlencoded do
  @moduledoc """
  Functions to work with `application/x-www-form-urlencoded`.

  The `application/x-www-form-urlencoded` percent-encode set is [defined](https://url.spec.whatwg.org/#application-x-www-form-urlencoded-percent-encode-set) as:

  > The `application/x-www-form-urlencoded `percent-encode set is the component percent-encode set and U+0021 (!), U+0027 (') to U+0029 RIGHT PARENTHESIS, inclusive, and U+007E (~).

  For performance, it reverses the condition by using the note in the specification:

  > The `application/x-www-form-urlencoded` percent-encode set contains all code points, except the ASCII alphanumeric, U+002A (*), U+002D (-), U+002E (.), and U+005F (_).

  See also:

  - [IANA - application/x-www-form-urlencoded](https://www.iana.org/assignments/media-types/application/x-www-form-urlencoded)
  - [`application/x-www-form-urlencoded` in URL Standard](https://url.spec.whatwg.org/#application/x-www-form-urlencoded)
  """

  alias WHATWG.PercentEncoding

  @doc """
  Parses a string into a list of pairs.

  ### Examples

      iex> parse("")
      []

      iex> parse("&&")
      []

      iex> parse("a=b=c")
      [{"a", "b=c"}]

      iex> parse("==a")
      [{"", "=a"}]

      iex> parse("%20a+=")
      [{" a ", ""}]

      iex> parse("=+b%20")
      [{"", " b "}]

      iex> parse("a")
      [{"a", ""}]
  """
  def parse(string) when is_binary(string) do
    sequences = :binary.split(string, "&", [:global])

    sequences
    |> Enum.reduce([], fn
      "", acc -> acc
      bytes, acc -> split_kv(bytes, acc)
    end)
    |> Enum.reverse()
  end

  defp split_kv(bytes, acc) do
    case :binary.split(bytes, "=") do
      [k, v] -> [{parse_decode(k), parse_decode(v)} | acc]
      [k] -> [{parse_decode(k), ""} | acc]
    end
  end

  defp parse_decode(bytes), do: PercentEncoding.decode_bytes(bytes, true)

  @doc """
  Serializes a list of pairs into a string.

  ### Examples

      iex> serialize([{"a ", ""}])
      "a+="

      iex> serialize([{"a", "1"}, {"a", "2"}])
      "a=1&a=2"

      iex> serialize([{:a, "1"}])
      ** (ArgumentError) expected a list with two-element tuples with binary elements must be given, got an entry: {:a, "1"}

      iex> serialize([{"a", 1}])
      ** (ArgumentError) expected a list with two-element tuples with binary elements must be given, got an entry: {"a", 1}

      iex> serialize([{:a, 1}], true)
      "a=1"

  """
  def serialize(list, to_str \\ false) when is_list(list) do
    list
    |> Enum.reduce([], &reduce_serialize_in_reverse(&1, &2, to_str))
    |> prune_head()
    |> Enum.reverse()
    |> IO.iodata_to_binary()
  end

  defp reduce_serialize_in_reverse({k, v}, acc, _to_str) when is_binary(k) and is_binary(v),
    do: [?&, [encode_bytes(k), "=", encode_bytes(v)] | acc]

  defp reduce_serialize_in_reverse({k, v}, acc, true),
    do: [?&, [encode_bytes(to_string(k)), "=", encode_bytes(to_string(v))] | acc]

  defp reduce_serialize_in_reverse(pair, _acc, _to_str) do
    raise(
      ArgumentError,
      "expected a list with two-element tuples with binary elements must be given, got an entry: #{inspect(pair)}"
    )
  end

  defp prune_head([?& | t]), do: t
  defp prune_head(list), do: list

  def encode_bytes(bytes), do: PercentEncoding.encode_bytes(bytes, &percent_encode_set?/1, true)

  @percent_encode_except ~c"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz*-._"

  defp percent_encode_set?(byte) when is_integer(byte) and byte not in @percent_encode_except,
    do: true

  defp percent_encode_set?(byte) when is_integer(byte), do: false
end
