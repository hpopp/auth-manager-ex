defmodule AuthManager.MixProject do
  use Mix.Project

  def project do
    [
      app: :auth_manager,
      version: "0.2.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      cli: cli(),
      test_coverage: [tool: SonarQube.Coverage, summary: [threshold: 0]],
      description: "Elixir client library for the auth-manager service"
    ]
  end

  def cli do
    [preferred_envs: ["sonarqube.coverage": :test]]
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
      {:req, "~> 0.5"},
      {:sonarqube, "~> 0.1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
