defmodule WHATWG.PercentEncoding do
  @moduledoc """
  Functions to work with percent-encoding.
  """

  @doc """
  Percent-encodes a byte in integer into a string.

  This function will raise `FunctionClauseError` if the given `char` is not an integer for a byte.

  See also:

  - [Percent-Encoding in RFC 3986 - Uniform Resource Identifier (URI): Generic Syntax](https://tools.ietf.org/html/rfc3986#section-2.1)
  - [Percent-encoded bytes in URL Standard](https://url.spec.whatwg.org/#percent-encoded-bytes)

  ### Examples

      iex> encode_byte(0x23)
      "%23"

      iex> encode_byte(0x7F)
      "%7F"

      iex> encode_byte(0x20)
      "%20"

      iex> encode_byte(256)
      ** (FunctionClauseError) no function clause matching in WHATWG.PercentEncoding.encode_byte/1
  """
  def encode_byte(char) when is_integer(char) and char >= 0x00 and char < 256 do
    <<"%", hex(Bitwise.bsr(char, 4)), hex(Bitwise.band(char, 15))>>
  end

  defp hex(n) when n <= 9, do: n + ?0
  defp hex(n), do: n + ?A - 10

  @doc """
  Percent-encodes bytes in a binary into a string.

  ### Examples

      iex> encode_bytes(<<0x23>>)
      "%23"

      iex> encode_bytes(<<0x7F>>)
      "%7F"

      iex> encode_bytes(" ")
      "%20"
  """
  def encode_bytes(binary) when is_binary(binary) do
    for <<byte <- binary>>, into: "", do: encode_byte(byte)
  end

  @doc """
  Percent-encodes bytes with `encode_set_func/1` func and `space_as_plus`.

  If the given function returns `true` for a byte, the byte will be percent-encoded.
  Otherwise, the byte will not be percent-encoded.

  If `space_as_plus` is `true`, `0x20` will be encoded to `+` instead of `"0x20"`.

  ### Examples

      iex> encode_bytes("a1", fn char -> char in ?0..?9 end)
      "a%31"

      iex> encode_bytes("a1 ", fn char -> char not in ?0..?9 and char not in ?a..?z end)
      "a1%20"

      iex> encode_bytes("a1 ", fn char -> char not in ?0..?9 and char not in ?a..?z end, true)
      "a1+"
  """
  def encode_bytes(binary, encode_set_func, space_as_plus \\ false)
      when is_binary(binary) and is_function(encode_set_func, 1) do
    for <<byte <- binary>>, into: "", do: encode_byte(byte, encode_set_func, space_as_plus)
  end

  defp encode_byte(0x20, _, true), do: "+"
  defp encode_byte(0x20, _, false), do: "%20"

  defp encode_byte(char, encode_set_func, _) do
    if encode_set_func.(char) do
      encode_byte(char)
    else
      <<char>>
    end
  end

  @doc """
  Percent-decodes a string into bytes.

  If `space_as_plus` is true, `+` will be decoded to `" "`.

  This function will raise `FunctionClauseError` if the given `string` is not a binary.

  ### Examples

      iex> decode_bytes("a%23b%25")
      "a#b%"

      iex> decode_bytes("%6a%6A")
      "jj"

      iex> decode_bytes("‽%25%2E")
      <<0xE2, 0x80, 0xBD, 0x25, 0x2E>>

      iex> decode_bytes("a%20+b")
      "a +b"

      iex> decode_bytes("a%20+b", true)
      "a  b"

      iex> decode_bytes("%GG")
      ** (ArgumentError) malformed percent encoding "%GG"

      iex> decode_bytes("a%0")
      ** (ArgumentError) malformed percent encoding "a%0"

      iex> decode_bytes("a%")
      ** (ArgumentError) malformed percent encoding "a%"

      iex> decode_bytes('a')
      ** (FunctionClauseError) no function clause matching in WHATWG.PercentEncoding.decode_bytes/2

      iex> decode_bytes('a')
      ** (FunctionClauseError) no function clause matching in WHATWG.PercentEncoding.decode_bytes/2

      iex> decode_bytes(<<1::4>>)
      ** (FunctionClauseError) no function clause matching in WHATWG.PercentEncoding.decode_bytes/2

  """
  def decode_bytes(string, space_as_plus \\ false)
      when is_binary(string) and is_boolean(space_as_plus) do
    decode_recursive(string, "", space_as_plus)
  catch
    :malformed_percent_encoding ->
      raise ArgumentError, "malformed percent encoding #{inspect(string)}"
  end

  defp decode_recursive(<<?%, hex1, hex2, tail::binary>>, acc, space_as_plus) do
    decode_recursive(
      tail,
      <<acc::binary, Bitwise.bsl(hex_to_dec(hex1), 4) + hex_to_dec(hex2)>>,
      space_as_plus
    )
  end

  defp decode_recursive(<<?%, _::binary>>, _acc, _space_as_plus),
    do: throw(:malformed_percent_encoding)

  defp decode_recursive(<<?+, tail::binary>>, acc, true),
    do: decode_recursive(tail, <<acc::binary, ?\s>>, true)

  defp decode_recursive(<<head, tail::binary>>, acc, space_as_plus),
    do: decode_recursive(tail, <<acc::binary, head>>, space_as_plus)

  defp decode_recursive(<<>>, acc, _spaces), do: acc

  defp hex_to_dec(n) when n in ?A..?F, do: n - ?A + 10
  defp hex_to_dec(n) when n in ?a..?f, do: n - ?a + 10
  defp hex_to_dec(n) when n in ?0..?9, do: n - ?0
  defp hex_to_dec(_n), do: throw(:malformed_percent_encoding)
end
