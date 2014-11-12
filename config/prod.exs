use Mix.Config

# ## SSL Support
#
# To get SSL working, you will need to set:
#
#     https: [port: 443,
#             keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#             certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables point to a file on
# disk for the key and cert.

config :phoenix, ComicBaker.Router,
  url: [host: "example.com"],
  http: [port: System.get_env("PORT")],
  secret_key_base: "isweYE3cG4ftHTP3Hh5bbAYTJC2Wavm8zYVzEw8lMVA4en8YQg56qaHNH6d126MDqVABhXSEGDkgSOGGtcCJGg=="

config :logger, :console,
  level: :info
