defmodule WHATWG.MixProject do
  use Mix.Project

  def project do
    [
      app: :whatwg,
      version: "0.0.1-dev",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end