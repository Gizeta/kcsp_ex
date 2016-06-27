defmodule KcspEx.Mixfile do
  use Mix.Project

  def project do
    [app: :kcsp_ex,
     version: "0.2.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:cowboy,
                    :eleveldb,
                    :httpoison,
                    :logger,
                    :plug],
     mod: {KcspEx, []}]
  end

  defp deps do
    [{:cowboy, "~> 1.0"},
     {:eleveldb, "~> 2.1"},
     {:exrm, "~> 1.0"},
     {:httpoison, "~> 0.8"},
     {:plug, "~> 1.1"}]
  end
end
