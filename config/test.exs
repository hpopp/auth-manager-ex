import Config

config :auth_manager,
  adapter: AuthManager.Adapter.Mock,
  endpoint: "http://localhost:8080"
