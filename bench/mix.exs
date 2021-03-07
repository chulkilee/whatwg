defmodule WHATWGBench.MixProject do
  use Mix.Project

  def project do
    [
      app: :whatwg_bench,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp aliases() do
    [
      "bench.decode_query": ["run decode_query.exs"],
      "bench.encode_bytes": ["run encode_bytes.exs"]
    ]
  end

  defp deps do
    [
      {:whatwg, ">= 0.0.0", path: "../"},
      {:benchee, "~> 1.0"}
    ]
  end
end
