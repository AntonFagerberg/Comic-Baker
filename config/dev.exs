use Mix.Config

config :phoenix, ComicBaker.Router,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true

# Enables code reloading for development
config :phoenix, :code_reloader, true
