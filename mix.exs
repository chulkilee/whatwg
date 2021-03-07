defmodule WHATWG.MixProject do
  use Mix.Project

  def project do
    [
      app: :whatwg,
      version: "0.0.1-dev",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # docs
      name: "WHATWG",
      source_url: "https://github.com/chulkilee/whatwg",
      homepage_url: "https://github.com/chulkilee/whatwg",
      docs: [
        main: "WHATWG",
        nest_modules_by_prefix: [WHATWG.Infra, WHATWG.URL]
      ],

      # test
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      maintainers: ["Chulki Lee"],
      links: %{
        "GitHub" => "https://github.com/chulkilee/whatwg",
        "Changelog" => "https://github.com/chulkilee/whatwg/blob/main/CHANGELOG.md"
      }
    ]
  end
end
