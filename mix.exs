defmodule WHATWG.MixProject do
  use Mix.Project

  def project do
    [
      app: :whatwg,
      version: "0.0.1-dev",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
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

  defp package do
    [
      licenses: ["Apache-2.0"],
      maintainers: ["Chulki Lee"]
    ]
  end
end
