defmodule AuthManager.Adapter.LiveTest do
  @moduledoc """
  Integration tests against a running auth-manager instance.

  Run with:

      mix test --include live

  Requires auth-manager running on localhost:8080 (or AUTH_MANAGER_ENDPOINT).
  """
  use ExUnit.Case

  @moduletag :live

  alias AuthManager.Adapter.Live

  describe "create_session/1" do
    test "creates a new session" do
      response = Live.create_session(%{subject_id: subject_id(), ttl_seconds: 300})

      assert response.status == "success"
      assert response.data["id"]
      assert response.data["token"]
      assert response.data["expires_at"]
    end

    test "creates a session with metadata and user agent" do
      sid = subject_id()

      %{data: %{"id" => id}} =
        Live.create_session(%{
          subject_id: sid,
          ip_address: "10.0.0.1",
          user_agent:
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
          ttl_seconds: 300,
          metadata: %{name: "Test User", role: "admin"}
        })

      response = Live.get_session(id)

      assert response.status == "success"
      assert response.data["device_info"]["browser"] == "Chrome"
      assert response.data["metadata"]["name"] == "Test User"
    end
  end

  describe "get_session/1" do
    test "gets a session by ID" do
      %{data: %{"id" => id}} =
        Live.create_session(%{subject_id: subject_id(), ttl_seconds: 300})

      response = Live.get_session(id)

      assert response.status == "success"
      assert response.data["id"] == id
    end

    test "returns NOT_FOUND if no session exists" do
      response = Live.get_session("00000000-0000-0000-0000-000000000000")
      assert_not_found(response)
    end
  end

  describe "list_sessions/1" do
    test "lists sessions filtered by subject_id" do
      sid = subject_id()
      Live.create_session(%{subject_id: sid, ttl_seconds: 300})

      response = Live.list_sessions(subject_id: sid)

      assert response.status == "success"
      assert response.data["items"] != []
    end

    test "returns empty list for nonexistent subject" do
      response = Live.list_sessions(subject_id: "nonexistent-#{subject_id()}")

      assert response.status == "success"
      assert response.data["items"] == []
      assert response.data["pagination"]["total"] == 0
    end
  end

  describe "verify_session/1" do
    test "returns session details if valid" do
      sid = subject_id()

      %{data: %{"token" => token}} =
        Live.create_session(%{subject_id: sid, ttl_seconds: 300})

      response = Live.verify_session(token)

      assert response.status == "success"
      assert response.data["id"]
      assert response.data["subject_id"] == sid
    end

    test "returns NOT_FOUND if no session exists" do
      response = Live.verify_session("not_real")
      assert_not_found(response)
    end
  end

  test "revoke_session/1 revokes a session" do
    %{data: %{"id" => id, "token" => token}} =
      Live.create_session(%{subject_id: subject_id(), ttl_seconds: 300})

    Live.revoke_session(id)

    response = Live.verify_session(token)
    assert_not_found(response)
  end

  describe "create_api_key/1" do
    test "creates a new API key" do
      sid = subject_id()

      response =
        Live.create_api_key(%{name: "Test Key", subject_id: sid, scopes: ["read", "write"]})

      assert response.status == "success"
      assert response.data["id"]
      assert response.data["key"]
      assert response.data["name"] == "Test Key"
      assert response.data["subject_id"] == sid
    end

    test "creates an API key with a custom key value" do
      custom = "custom-#{subject_id()}"

      response =
        Live.create_api_key(%{
          name: "Custom Key",
          subject_id: subject_id(),
          key: custom,
          scopes: ["view"]
        })

      assert response.status == "success"
      assert response.data["key"] == custom
    end
  end

  describe "get_api_key/1" do
    test "gets an API key by ID" do
      %{data: %{"id" => id}} =
        Live.create_api_key(%{name: "Test Key", subject_id: subject_id(), scopes: ["read"]})

      response = Live.get_api_key(id)

      assert response.status == "success"
      assert response.data["id"] == id
      assert response.data["name"] == "Test Key"
    end

    test "returns NOT_FOUND if no API key exists" do
      response = Live.get_api_key("00000000-0000-0000-0000-000000000000")
      assert_not_found(response)
    end
  end

  describe "list_api_keys/1" do
    test "lists API keys filtered by subject_id" do
      sid = subject_id()
      Live.create_api_key(%{name: "Test Key", subject_id: sid, scopes: ["read"]})

      response = Live.list_api_keys(subject_id: sid)

      assert response.status == "success"
      assert response.data["items"] != []
    end

    test "returns empty list for nonexistent subject" do
      response = Live.list_api_keys(subject_id: "nonexistent-#{subject_id()}")

      assert response.status == "success"
      assert response.data["items"] == []
      assert response.data["pagination"]["total"] == 0
    end
  end

  test "update_api_key/2 updates an API key" do
    %{data: %{"id" => id}} =
      Live.create_api_key(%{name: "Original", subject_id: subject_id(), scopes: ["read"]})

    response = Live.update_api_key(id, %{name: "Updated", scopes: ["read", "write", "admin"]})

    assert response.status == "success"
    assert response.data["name"] == "Updated"
    assert length(response.data["scopes"]) == 3
  end

  describe "verify_api_key/1" do
    test "returns API key details if valid" do
      sid = subject_id()

      %{data: %{"key" => key}} =
        Live.create_api_key(%{name: "Test Key", subject_id: sid, scopes: ["read"]})

      response = Live.verify_api_key(key)

      assert response.status == "success"
      assert response.data["id"]
      assert response.data["name"] == "Test Key"
      assert response.data["subject_id"] == sid
    end

    test "returns NOT_FOUND if no API key exists" do
      response = Live.verify_api_key("not_real")
      assert_not_found(response)
    end
  end

  test "revoke_api_key/1 revokes an API key" do
    %{data: %{"id" => id, "key" => key}} =
      Live.create_api_key(%{name: "Test Key", subject_id: subject_id(), scopes: ["read"]})

    Live.revoke_api_key(id)

    response = Live.verify_api_key(key)
    assert_not_found(response)
  end

  describe "parse_user_agent/1" do
    test "parses Chrome on macOS" do
      ua =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

      response = Live.parse_user_agent(ua)

      assert response.status == "success"
      assert response.data["browser"] == "Chrome"
      assert response.data["kind"] == "Desktop"
    end

    test "parses Safari on iOS" do
      ua =
        "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

      response = Live.parse_user_agent(ua)

      assert response.status == "success"
      assert response.data["browser"] == "Safari"
      assert response.data["kind"] == "Mobile"
    end

    test "returns fail for empty user agent" do
      response = Live.parse_user_agent("")
      assert response.status == "fail"
    end
  end

  defp subject_id do
    1_000_000 |> :rand.uniform() |> to_string()
  end

  defp assert_not_found(response) do
    assert response.status == "fail"
    assert response.data["message"]
  end
end
