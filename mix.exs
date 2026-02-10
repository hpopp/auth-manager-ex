defmodule AuthManager.MixProject do
  use Mix.Project

  def project do
    [
      app: :auth_manager,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Elixir client library for the auth-manager service"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: [:dev], runtime: false},
      {:jsend, "~> 0.1.0"},
      {:req, "~> 0.5"}
    ]
  end
end
