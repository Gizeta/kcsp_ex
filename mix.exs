defmodule KcspEx.Mixfile do
  use Mix.Project

  def project do
    [app: :kcsp_ex,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:cowboy,
                    :httpoison,
                    :logger,
                    :plug,
                    :ssdb],
     mod: {KcspEx, []}]
  end

  defp deps do
    [{:cowboy, "~> 1.0"},
     {:httpoison, "~> 0.8"},
     {:plug, "~> 1.1"},
     {:ssdb, github: "Gizeta/ssdb-elixir", branch: "bump"}]
  end
end
