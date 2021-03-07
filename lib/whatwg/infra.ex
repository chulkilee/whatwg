defmodule WHATWG.Infra do
  @moduledoc """
  Functions for [Infra Standard](https://infra.spec.whatwg.org).
  """

  @doc """
  Returns `true` if `term` is an integer for a surrogate; otherwise returns `false`.

  > A **surrogate** is a code point that is in the range U+D800 to U+DFFF, inclusive.
  """
  defguard is_surrogate(term) when term in 0xD800..0xDFFF

  @doc """
  Returns `true` if `term` is an integer for a scalar value; otherwise returns `false`.

  > A **scalar value** is a code point that is not a surrogate.
  """
  defguard is_scalar_value(term) when not is_surrogate(term)

  @doc """
  Returns `true` if `term` is an integer for a noncharacter; otherwise returns `false`.

  > A **noncharacter** is a code point that is in the range U+FDD0 to U+FDEF, inclusive, or U+FFFE, U+FFFF, U+1FFFE, U+1FFFF, U+2FFFE, U+2FFFF, U+3FFFE, U+3FFFF, U+4FFFE, U+4FFFF, U+5FFFE, U+5FFFF, U+6FFFE, U+6FFFF, U+7FFFE, U+7FFFF, U+8FFFE, U+8FFFF, U+9FFFE, U+9FFFF, U+AFFFE, U+AFFFF, U+BFFFE, U+BFFFF, U+CFFFE, U+CFFFF, U+DFFFE, U+DFFFF, U+EFFFE, U+EFFFF, U+FFFFE, U+FFFFF, U+10FFFE, or U+10FFFF.
  """
  defguard is_noncharacter(term)
           when term in 0xFDD0..0xFDEF or
                  term in [
                    0xFFFE,
                    0xFFFF,
                    0x1FFFE,
                    0x1FFFF,
                    0x2FFFE,
                    0x2FFFF,
                    0x3FFFE,
                    0x3FFFF,
                    0x4FFFE,
                    0x4FFFF,
                    0x5FFFE,
                    0x5FFFF,
                    0x6FFFE,
                    0x6FFFF,
                    0x7FFFE,
                    0x7FFFF,
                    0x8FFFE,
                    0x8FFFF,
                    0x9FFFE,
                    0x9FFFF,
                    0xAFFFE,
                    0xAFFFF,
                    0xBFFFE,
                    0xBFFFF,
                    0xCFFFE,
                    0xCFFFF,
                    0xDFFFE,
                    0xDFFFF,
                    0xEFFFE,
                    0xEFFFF,
                    0xFFFFE,
                    0xFFFFF,
                    0x10FFFE,
                    0x10FFFF
                  ]

  @doc """
  Returns `true` if `term` is an integer for an ASCII code point; otherwise returns `false`.

  > An **ASCII code point** is a code point in the range U+0000 NULL to U+007F DELETE, inclusive.
  """
  defguard is_ascii_code_point(term) when term in 0x00..0x7F

  @doc """
  Returns `true` if `term` is an integer for an ASCII tab or newline; otherwise returns `false`.

  > An **ASCII tab or newline** is U+0009 TAB, U+000A LF, or U+000D CR.
  """
  defguard is_ascii_tab_or_newline(term) when term in [0x09, 0x0A, 0x0D]

  @doc """
  Returns `true` if `term` is an integer for ASCII whitespace; otherwise returns `false`.

  > **ASCII whitespace** is U+0009 TAB, U+000A LF, U+000C FF, U+000D CR, or U+0020 SPACE.
  """
  defguard is_ascii_whitespace(term) when term in [0x09, 0x0A, 0x0C, 0x0D, 0x20]

  @doc """
  Returns `true` if `term` is an integer for a C0 control; otherwise returns `false`.

  > A **C0 control** is a code point in the range U+0000 NULL to U+001F INFORMATION SEPARATOR ONE, inclusive.
  """
  defguard is_c0_control(term) when term in 0x00..0x1F

  @doc """
  Returns `true` if `term` is an integer for an U+0020 SPACE; otherwise returns `false`.
  """

  defguard is_space(term) when term == 0x20

  @doc """
  Returns `true` if `term` is an integer for a control; otherwise returns `false`.

  > A **control** is a C0 control or a code point in the range U+007F DELETE to U+009F APPLICATION PROGRAM COMMAND, inclusive.
  """
  defguard is_control(term) when is_c0_control(term) or term in 0x007F..0x009F

  @doc """
  Returns `true` if `term` is an integer for an ASCII digit; otherwise returns `false`.

  > An **ASCII digit** is a code point in the range U+0030 (0) to U+0039 (9), inclusive.
  """
  defguard is_ascii_digit(term) when term in '0123456789'

  @doc """
  Returns `true` if `term` is an integer for an ASCII upper hex digit; otherwise returns `false`.

  > An **ASCII upper hex digit** is an ASCII digit or a code point in the range U+0041 (A) to U+0046 (F), inclusive.
  """
  defguard is_ascii_upper_hex_digit(term) when term in 'ABCDEF'

  @doc """
  Returns `true` if `term` is an integer for an ASCII lower hex digit; otherwise returns `false`.

  > An **ASCII lower hex digit** is an ASCII digit or a code point in the range U+0061 (a) to U+0066 (f), inclusive.
  """
  defguard is_ascii_lower_hex_digit(term) when term in 'abcdef'

  @doc """
  Returns `true` if `term` is an integer for an ASCII hex digit; otherwise returns `false`.

  > An **ASCII hex digit** is an ASCII upper hex digit or ASCII lower hex digit.
  """
  defguard is_ascii_hex_digit(term)
           when is_ascii_upper_hex_digit(term) or is_ascii_lower_hex_digit(term)

  @doc """
  Returns `true` if `term` is an integer for an ASCII upper alpha; otherwise returns `false`.

  > An **ASCII upper alpha** is a code point in the range U+0041 (A) to U+005A (Z), inclusive.
  """
  defguard is_ascii_upper_alpha(term) when term in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  @doc """
  Returns `true` if `term` is an integer for an ASCII lower alpha; otherwise returns `false`.

  > An **ASCII lower alpha** is a code point in the range U+0061 (a) to U+007A (z), inclusive.
  """
  defguard is_ascii_lower_alpha(term) when term in 'abcdefghijklmnopqrstuvwxyz'

  @doc """
  Returns `true` if `term` is an integer for an ASCII alpha; otherwise returns `false`.

  > An **ASCII alpha** is an ASCII upper alpha or ASCII lower alpha.
  """
  defguard is_ascii_alpha(term) when is_ascii_upper_alpha(term) or is_ascii_lower_alpha(term)

  @doc """
  Returns `true` if `term` is an integer for an ASCII alphanumeric; otherwise returns `false`.

  > An **ASCII alphanumeric** is an ASCII digit or ASCII alpha.
  """
  defguard is_ascii_alphanumeric(term) when is_ascii_digit(term) or is_ascii_alpha(term)
end
