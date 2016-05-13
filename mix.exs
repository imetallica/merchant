defmodule Merchant.Mixfile do
  use Mix.Project

  @version "0.0.1-alpha"
  @url "https://github.com/imetallica/merchant"
  @maintainers [
    "Iuri L. Machado"
  ]

  def project do
    [name: "Merchant",
     app: :merchant,
     version: @version,
     source_url: @url,
     elixir: "~> 1.2",
     description: description,
     package: package,
     deps: deps,
     docs: docs]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:decimal, "~> 1.1"},
     {:earmark, ">= 0.0.0"},
     {:ex_doc, "~> 0.11", only: [:docs, :dev]},
     {:credo, "~> 0.3", only: [:dev, :test]},
    ]
  end
  
  defp description do
    "Integrate payments into your site."
  end
  
  defp package do
    [name: :merchant,
     files: ["lib", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     maintainers: @maintainers,
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => @url}]
  end

  defp docs do
    [
      extras: ["README.md"]
    ]
  end
end