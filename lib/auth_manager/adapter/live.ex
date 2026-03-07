defmodule AuthManager.Adapter.Live do
  @moduledoc """
  Production implementation of `AuthManager.Adapter`.

  Service endpoint can be set by application configuration.

  Mix config:
  ```
  config :auth_manager, endpoint: "http://localhost:8080"
  ```

  Or via environment variable:
  ```
  AUTH_MANAGER_ENDPOINT=http://localhost:8080
  ```
  """

  require Logger

  @behaviour AuthManager.Adapter

  @impl true
  @spec create_session(%{atom() => term()}) :: JSend.t()
  def create_session(params) do
    case Req.post(client(), url: "/sessions", json: params) do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec get_session(String.t()) :: JSend.t()
  def get_session(id) do
    case Req.get(client(), url: "/sessions/#{id}") do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec list_sessions(keyword()) :: JSend.t()
  def list_sessions(opts \\ []) do
    params = build_list_params(opts)

    case Req.get(client(), url: "/sessions", params: params) do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec verify_session(String.t()) :: JSend.t()
  def verify_session(token) do
    case Req.post(client(), url: "/sessions/verify", json: %{token: token}) do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec revoke_session(String.t()) :: JSend.t()
  def revoke_session(id) do
    case Req.delete(client(), url: "/sessions/#{id}") do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec revoke_session_by_token(String.t()) :: JSend.t()
  def revoke_session_by_token(token) do
    case Req.post(client(), url: "/sessions/revoke", json: %{token: token}) do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec create_api_key(%{atom() => term()}) :: JSend.t()
  def create_api_key(params) do
    case Req.post(client(), url: "/api-keys", json: params) do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec get_api_key(String.t()) :: JSend.t()
  def get_api_key(id) do
    case Req.get(client(), url: "/api-keys/#{id}") do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec list_api_keys(keyword()) :: JSend.t()
  def list_api_keys(opts \\ []) do
    params = build_list_params(opts)

    case Req.get(client(), url: "/api-keys", params: params) do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec update_api_key(String.t(), %{atom() => term()}) :: JSend.t()
  def update_api_key(id, params) do
    case Req.put(client(), url: "/api-keys/#{id}", json: params) do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec verify_api_key(String.t()) :: JSend.t()
  def verify_api_key(key) do
    case Req.post(client(), url: "/api-keys/verify", json: %{key: key}) do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec revoke_api_key(String.t()) :: JSend.t()
  def revoke_api_key(id) do
    case Req.delete(client(), url: "/api-keys/#{id}") do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @impl true
  @spec parse_user_agent(String.t()) :: JSend.t()
  def parse_user_agent(user_agent) do
    case Req.post(client(), url: "/user-agents/parse", json: %{user_agent: user_agent}) do
      {:ok, resp} -> decode_response(resp.body)
      {:error, exception} -> error_response(exception)
    end
  end

  @spec decode_response(%{String.t() => term()}) :: JSend.t()
  defp decode_response(body) do
    %JSend{
      status: body["status"],
      data: body["data"],
      code: body["code"],
      message: body["message"]
    }
  end

  @spec error_response(Exception.t()) :: JSend.t()
  defp error_response(exception) do
    JSend.error("AuthManager has encountered an error.", Exception.message(exception))
  end

  @spec endpoint_url :: String.t() | no_return()
  defp endpoint_url do
    endpoint =
      System.get_env("AUTH_MANAGER_ENDPOINT") ||
        Application.get_env(:auth_manager, :endpoint)

    case endpoint do
      nil -> raise "AUTH_MANAGER_ENDPOINT not set"
      endpoint -> endpoint
    end
  end

  @spec client :: Req.Request.t()
  defp client do
    Req.new(base_url: endpoint_url())
  end

  @spec build_list_params(keyword()) :: [{String.t(), term()}]
  defp build_list_params(opts) do
    []
    |> maybe_add("subject_id", Keyword.get(opts, :subject_id))
    |> maybe_add("limit", Keyword.get(opts, :limit))
    |> maybe_add("offset", Keyword.get(opts, :offset))
  end

  defp maybe_add(params, _key, nil), do: params
  defp maybe_add(params, key, value), do: [{key, value} | params]
end
