defmodule AuthManager.Adapter.Mock do
  @moduledoc """
  Mock implementation of `AuthManager.Adapter`.
  """

  @behaviour AuthManager.Adapter

  @impl true
  def create_session(params) do
    params = stringify_keys(params)
    subject_id = params["subject_id"] || "user-123"

    JSend.success(%{
      "id" => "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "token" => "mock-session-token",
      "subject_id" => subject_id,
      "ip_address" => params["ip_address"] || "127.0.0.1",
      "device_info" => %{
        "browser" => "Chrome",
        "kind" => "Desktop",
        "os" => "Mac OSX"
      },
      "metadata" => params["metadata"],
      "expires_at" => "2030-01-01T00:00:00Z"
    })
  end

  @impl true
  def get_session("not_found"), do: not_found()

  def get_session(id) do
    JSend.success(mock_session(id))
  end

  @impl true
  def list_sessions(_opts) do
    JSend.success(%{
      "items" => [mock_session("a1b2c3d4-e5f6-7890-abcd-ef1234567890")],
      "pagination" => %{"limit" => 20, "offset" => 0, "total" => 1}
    })
  end

  @impl true
  def verify_session("not_found"), do: not_found()

  def verify_session(_token) do
    JSend.success(mock_session("a1b2c3d4-e5f6-7890-abcd-ef1234567890"))
  end

  @impl true
  def revoke_session(_id) do
    JSend.success(%{})
  end

  @impl true
  def revoke_session_by_token(_token) do
    JSend.success(%{})
  end

  @impl true
  def create_api_key(params) do
    params = stringify_keys(params)

    JSend.success(%{
      "id" => "b2c3d4e5-f6a7-8901-bcde-f12345678901",
      "key" => params["key"] || "mock-api-key-value",
      "name" => params["name"] || "Example Key",
      "subject_id" => params["subject_id"] || "user-123",
      "description" => params["description"],
      "scopes" => params["scopes"] || ["read"],
      "expires_at" => nil
    })
  end

  @impl true
  def get_api_key("not_found"), do: not_found()

  def get_api_key(id) do
    JSend.success(mock_api_key(id))
  end

  @impl true
  def list_api_keys(_opts) do
    JSend.success(%{
      "items" => [mock_api_key("b2c3d4e5-f6a7-8901-bcde-f12345678901")],
      "pagination" => %{"limit" => 20, "offset" => 0, "total" => 1}
    })
  end

  @impl true
  def update_api_key(id, params) do
    params = stringify_keys(params)
    base = mock_api_key(id)
    JSend.success(Map.merge(base, params))
  end

  @impl true
  def verify_api_key("not_found"), do: not_found()

  def verify_api_key(_key) do
    JSend.success(mock_api_key("b2c3d4e5-f6a7-8901-bcde-f12345678901"))
  end

  @impl true
  def revoke_api_key(_id) do
    JSend.success(%{})
  end

  @impl true
  def parse_user_agent(_user_agent) do
    JSend.success(%{
      "browser" => "Chrome",
      "kind" => "Desktop",
      "os" => "Mac OSX"
    })
  end

  defp mock_session(id) do
    %{
      "id" => id,
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
  end

  defp mock_api_key(id) do
    %{
      "id" => id,
      "name" => "Example Key",
      "subject_id" => "user-123",
      "description" => "An example key.",
      "scopes" => ["read"],
      "expires_at" => nil
    }
  end

  defp not_found(message \\ "Not found") do
    JSend.fail(%{"message" => message})
  end

  defp stringify_keys(map) do
    for {key, val} <- map, into: %{}, do: {to_string(key), val}
  end
end
