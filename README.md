# AuthManager

> Elixir client library for the [auth-manager](https://github.com/hpopp/auth-manager) service.

## Installation

Add `auth_manager` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:auth_manager, git: "git@github.com:hpopp/auth-manager-ex.git", tag: "v0.1.0"}
  ]
end
```

## Configuration

```elixir
config :auth_manager,
  adapter: AuthManager.Adapter.Live,
  endpoint: "http://localhost:8080"
```

Or via environment variable:

```
AUTH_MANAGER_ENDPOINT=http://localhost:8080
```

## Usage

```elixir
# Sessions
AuthManager.create_session(%{subject_id: "user-123", ttl_seconds: 3600})
AuthManager.verify_session("token-value")
AuthManager.get_session("uuid")
AuthManager.list_sessions(subject_id: "user-123")
AuthManager.revoke_session("uuid")

# API Keys
AuthManager.create_api_key(%{name: "My Key", subject_id: "user-123", scopes: ["read"]})
AuthManager.verify_api_key("key-value")
AuthManager.get_api_key("uuid")
AuthManager.list_api_keys(subject_id: "user-123")
AuthManager.update_api_key("uuid", %{name: "Updated Name"})
AuthManager.revoke_api_key("uuid")

# User Agents
AuthManager.parse_user_agent("Mozilla/5.0 ...")
```

## Testing

Use the mock adapter in your test config:

```elixir
config :auth_manager, adapter: AuthManager.Adapter.Mock
```

## License

Copyright (c) 2026 Henry Popp

This project is MIT licensed. See the [LICENSE](LICENSE) for details.
