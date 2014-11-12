defmodule ComicBaker.Mixfile do
  use Mix.Project

  def project do
    [app: :comic_baker,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {ComicBaker, []},
     applications: [:phoenix, :cowboy, :logger, :postgrex, :ecto, :pbkdf2]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "0.5.0"},
     {:cowboy, "~> 1.0"},
     {:postgrex, ">= 0.0.0"},
     {:ecto, "~> 0.2.0"},
     {:pbkdf2, git: "https://github.com/basho/erlang-pbkdf2.git", tag: "2.0.0"}]
  end
end
