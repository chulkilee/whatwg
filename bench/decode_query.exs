uniq =
  ?a..?z
  |> Enum.map(fn val -> {to_string([val]), Integer.to_string(val)} end)
  |> URI.encode_query()

Benchee.run(
  %{
    "WHATWG.URL.WwwFormUrlencoded.parse/1" => &WHATWG.URL.WwwFormUrlencoded.parse/1,
    "WHATWG.URL.WwwFormUrlencoded.parse/1 |> Enum.into/2" =>
      &Enum.into(WHATWG.URL.WwwFormUrlencoded.parse(&1), %{}),
    "URI.decode_query/1" => &URI.decode_query/1
  },
  inputs: %{
    "unique" => uniq,
    "10 dup" => uniq |> List.duplicate(10) |> Enum.join("&"),
    "100 dup" => uniq |> List.duplicate(100) |> Enum.join("&")
  },
  memory_time: 2
)
