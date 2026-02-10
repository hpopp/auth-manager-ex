import Config

config :auth_manager,
  adapter: AuthManager.Adapter.Live,
  endpoint: "http://localhost:8080"
