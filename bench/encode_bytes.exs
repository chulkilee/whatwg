to_encode = 32..126 |> Enum.map(fn val -> to_string([val]) end) |> Enum.join("")

Benchee.run(
  %{
    "WHATWG.URL.WwwFormUrlencoded.encode_bytes/1" => fn ->
      WHATWG.URL.WwwFormUrlencoded.encode_bytes(to_encode)
    end,
    "URI.encode_www_form/1" => fn -> URI.encode_www_form(to_encode) end
  },
  memory_time: 2
)
