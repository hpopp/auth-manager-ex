defmodule AuthManager do
  @moduledoc """
  Elixir client library for the auth-manager service.
  """

  @doc """
  Returns currently configured adapter.
  """
  @spec adapter :: module
  def adapter do
    Application.get_env(:auth_manager, :adapter, AuthManager.Adapter.Live)
  end

  @doc ~S"""
  Create a session.

  ## Examples

      iex> AuthManager.create_session(%{subject_id: "user-123",
      ...> ip_address: "127.0.0.1", user_agent: "Chrome", ttl_seconds: 3600})
      %JSend{
        status: "success",
        data: %{
          "id" => "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
          "token" => "mock-session-token",
          "subject_id" => "user-123",
          "ip_address" => "127.0.0.1",
          "device_info" => %{
            "browser" => "Chrome",
            "kind" => "Desktop",
            "os" => "Mac OSX"
          },
          "metadata" => nil,
          "expires_at" => "2030-01-01T00:00:00Z"
        }
      }
  """
  @spec create_session(map()) :: JSend.t()
  def create_session(params) do
    adapter().create_session(params)
  end

  @doc ~S"""
  Get a session by ID.

  ## Examples

      iex> AuthManager.get_session("a1b2c3d4-e5f6-7890-abcd-ef1234567890")
      %JSend{
        status: "success",
        data: %{
          "id" => "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
          "subject_id" => "user-123",
          "ip_address" => "127.0.0.1",
          "device_info" => %{
            "browser" => "Chrome",
            "kind" => "Desktop",
            "os" => "Mac OSX"
          },
          "metadata" => %{"role" => "admin"},
          "expires_at" => "2030-01-01T00:00:00Z"
        }
      }

      iex> AuthManager.get_session("not_found")
      %JSend{
        status: "fail",
        data: %{
          "message" => "Not found"
        }
      }
  """
  @spec get_session(String.t()) :: JSend.t()
  def get_session(id) do
    adapter().get_session(id)
  end

  @doc ~S"""
  List sessions with optional filters.

  ## Options

    * `:subject_id` - filter by subject ID
    * `:limit` - max number of results
    * `:offset` - number of results to skip

  ## Examples

      iex> AuthManager.list_sessions(subject_id: "user-123")
      %JSend{
        status: "success",
        data: %{
          "items" => [
            %{
              "id" => "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
              "subject_id" => "user-123",
              "ip_address" => "127.0.0.1",
              "device_info" => %{
                "browser" => "Chrome",
                "kind" => "Desktop",
                "os" => "Mac OSX"
              },
              "metadata" => %{"role" => "admin"},
              "expires_at" => "2030-01-01T00:00:00Z"
            }
          ],
          "pagination" => %{"limit" => 20, "offset" => 0, "total" => 1}
        }
      }
  """
  @spec list_sessions(keyword()) :: JSend.t()
  def list_sessions(opts \\ []) do
    adapter().list_sessions(opts)
  end

  @doc ~S"""
  Verify a session by token.

  ## Examples

      iex> AuthManager.verify_session("example-token")
      %JSend{
        status: "success",
        data: %{
          "id" => "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
          "subject_id" => "user-123",
          "ip_address" => "127.0.0.1",
          "device_info" => %{
            "browser" => "Chrome",
            "kind" => "Desktop",
            "os" => "Mac OSX"
          },
          "metadata" => %{"role" => "admin"},
          "expires_at" => "2030-01-01T00:00:00Z"
        }
      }

      iex> AuthManager.verify_session("not_found")
      %JSend{
        status: "fail",
        data: %{
          "message" => "Not found"
        }
      }
  """
  @spec verify_session(String.t()) :: JSend.t()
  def verify_session(token) do
    adapter().verify_session(token)
  end

  @doc ~S"""
  Revoke a session by ID.

  ## Examples

      iex> AuthManager.revoke_session("a1b2c3d4-e5f6-7890-abcd-ef1234567890")
      %JSend{
        status: "success",
        data: %{}
      }
  """
  @spec revoke_session(String.t()) :: JSend.t()
  def revoke_session(id) do
    adapter().revoke_session(id)
  end

  @doc ~S"""
  Revoke a session by token.

  ## Examples

      iex> AuthManager.revoke_session_by_token("example-token")
      %JSend{
        status: "success",
        data: %{}
      }
  """
  @spec revoke_session_by_token(String.t()) :: JSend.t()
  def revoke_session_by_token(token) do
    adapter().revoke_session_by_token(token)
  end

  @doc ~S"""
  Create an API key.

  ## Examples

      iex> AuthManager.create_api_key(%{name: "Example Key",
      ...> subject_id: "user-123", scopes: ["read"]})
      %JSend{
        status: "success",
        data: %{
          "id" => "b2c3d4e5-f6a7-8901-bcde-f12345678901",
          "key" => "mock-api-key-value",
          "name" => "Example Key",
          "subject_id" => "user-123",
          "description" => nil,
          "scopes" => ["read"],
          "expires_at" => nil
        }
      }
  """
  @spec create_api_key(map()) :: JSend.t()
  def create_api_key(params) do
    adapter().create_api_key(params)
  end

  @doc ~S"""
  Get an API key by ID.

  ## Examples

      iex> AuthManager.get_api_key("b2c3d4e5-f6a7-8901-bcde-f12345678901")
      %JSend{
        status: "success",
        data: %{
          "id" => "b2c3d4e5-f6a7-8901-bcde-f12345678901",
          "name" => "Example Key",
          "subject_id" => "user-123",
          "description" => "An example key.",
          "scopes" => ["read"],
          "expires_at" => nil
        }
      }

      iex> AuthManager.get_api_key("not_found")
      %JSend{
        status: "fail",
        data: %{
          "message" => "Not found"
        }
      }
  """
  @spec get_api_key(String.t()) :: JSend.t()
  def get_api_key(id) do
    adapter().get_api_key(id)
  end

  @doc ~S"""
  List API keys with optional filters.

  ## Options

    * `:subject_id` - filter by subject ID
    * `:limit` - max number of results
    * `:offset` - number of results to skip

  ## Examples

      iex> AuthManager.list_api_keys(subject_id: "user-123")
      %JSend{
        status: "success",
        data: %{
          "items" => [
            %{
              "id" => "b2c3d4e5-f6a7-8901-bcde-f12345678901",
              "name" => "Example Key",
              "subject_id" => "user-123",
              "description" => "An example key.",
              "scopes" => ["read"],
              "expires_at" => nil
            }
          ],
          "pagination" => %{"limit" => 20, "offset" => 0, "total" => 1}
        }
      }
  """
  @spec list_api_keys(keyword()) :: JSend.t()
  def list_api_keys(opts \\ []) do
    adapter().list_api_keys(opts)
  end

  @doc ~S"""
  Update an API key by ID.

  ## Examples

      iex> AuthManager.update_api_key("b2c3d4e5-f6a7-8901-bcde-f12345678901",
      ...> %{name: "Updated Key"})
      %JSend{
        status: "success",
        data: %{
          "id" => "b2c3d4e5-f6a7-8901-bcde-f12345678901",
          "name" => "Updated Key",
          "subject_id" => "user-123",
          "description" => "An example key.",
          "scopes" => ["read"],
          "expires_at" => nil
        }
      }
  """
  @spec update_api_key(String.t(), map()) :: JSend.t()
  def update_api_key(id, params) do
    adapter().update_api_key(id, params)
  end

  @doc ~S"""
  Verify an API key by value.

  ## Examples

      iex> AuthManager.verify_api_key("example-key")
      %JSend{
        status: "success",
        data: %{
          "id" => "b2c3d4e5-f6a7-8901-bcde-f12345678901",
          "name" => "Example Key",
          "subject_id" => "user-123",
          "description" => "An example key.",
          "scopes" => ["read"],
          "expires_at" => nil
        }
      }

      iex> AuthManager.verify_api_key("not_found")
      %JSend{
        status: "fail",
        data: %{
          "message" => "Not found"
        }
      }
  """
  @spec verify_api_key(String.t()) :: JSend.t()
  def verify_api_key(key) do
    adapter().verify_api_key(key)
  end

  @doc ~S"""
  Revoke an API key by ID.

  ## Examples

      iex> AuthManager.revoke_api_key("b2c3d4e5-f6a7-8901-bcde-f12345678901")
      %JSend{
        status: "success",
        data: %{}
      }
  """
  @spec revoke_api_key(String.t()) :: JSend.t()
  def revoke_api_key(id) do
    adapter().revoke_api_key(id)
  end

  @doc ~S"""
  Parse a user agent string.

  ## Examples

      iex> AuthManager.parse_user_agent("Mozilla/5.0 Chrome/120.0.0.0")
      %JSend{
        status: "success",
        data: %{
          "browser" => "Chrome",
          "kind" => "Desktop",
          "os" => "Mac OSX"
        }
      }
  """
  @spec parse_user_agent(String.t()) :: JSend.t()
  def parse_user_agent(user_agent) do
    adapter().parse_user_agent(user_agent)
  end
end
