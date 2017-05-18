defmodule ExPlugRouter.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_plug_router,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:plug, "~> 1.1.4"},
      {:poison, "~> 2.2"}
    ]
  end
end
