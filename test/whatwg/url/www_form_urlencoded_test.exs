defmodule WHATWG.URL.WwwFormUrlencodedTest do
  use ExUnit.Case

  import WHATWG.URL.WwwFormUrlencoded

  doctest WHATWG.URL.WwwFormUrlencoded

  describe "serialize/1" do
    test "works like URI.encode_query/1" do
      inputs = [
        {[{"a", ""}], "a="},
        {[{"", ""}], "="},
        {[{" a ", " b "}], "+a+=+b+"}
      ]

      inputs
      |> Enum.each(fn {input, expected} ->
        assert expected == URI.encode_query(input)
        assert expected == serialize(input)
      end)
    end
  end

  describe "encode_bytes/1" do
    test "encodes special chars like URI.encode_www_form/1 except 0x2A" do
      inputs = [
        {"!@#$%^&()-=_+[]{}\\|;:'\",./<>? \t\r\n",
         "%21%40%23%24%25%5E%26%28%29-%3D_%2B%5B%5D%7B%7D%5C%7C%3B%3A%27%22%2C.%2F%3C%3E%3F+%09%0D%0A"}
      ]

      inputs
      |> Enum.each(fn {input, expected} ->
        assert expected == URI.encode_www_form(input)
        assert expected == encode_bytes(input)
      end)
    end

    test "does not encode 0x2A unlike URI.encode_www_form/1" do
      assert "%2A" == URI.encode_www_form("*")
      assert "*" == encode_bytes("*")
    end

    test "encodes unicode chars like URI.encode_www_form/1" do
      inputs = [
        {"가나다", "%EA%B0%80%EB%82%98%EB%8B%A4"}
      ]

      inputs
      |> Enum.each(fn {input, expected} ->
        assert expected == URI.encode_www_form(input)
        assert expected == encode_bytes(input)
      end)
    end
  end
end
