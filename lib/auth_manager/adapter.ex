defmodule AuthManager.Adapter do
  @moduledoc """
  Adapter behaviour for AuthManager calls.

  ## Available Adapters
    - `AuthManager.Adapter.Live`
    - `AuthManager.Adapter.Mock`
  """

  @doc ~S"""
  Create a session.
  """
  @callback create_session(%{(String.t() | atom()) => any}) :: JSend.t()

  @doc ~S"""
  Get a session by ID.
  """
  @callback get_session(String.t()) :: JSend.t()

  @doc ~S"""
  List sessions with optional filters.
  """
  @callback list_sessions(keyword()) :: JSend.t()

  @doc ~S"""
  Verify a session by token.
  """
  @callback verify_session(String.t()) :: JSend.t()

  @doc ~S"""
  Revoke a session by ID.
  """
  @callback revoke_session(String.t()) :: JSend.t()

  @doc ~S"""
  Create an API key.
  """
  @callback create_api_key(%{(String.t() | atom()) => any}) :: JSend.t()

  @doc ~S"""
  Get an API key by ID.
  """
  @callback get_api_key(String.t()) :: JSend.t()

  @doc ~S"""
  List API keys with optional filters.
  """
  @callback list_api_keys(keyword()) :: JSend.t()

  @doc ~S"""
  Update an API key by ID.
  """
  @callback update_api_key(String.t(), %{(String.t() | atom()) => any}) :: JSend.t()

  @doc ~S"""
  Verify an API key by value.
  """
  @callback verify_api_key(String.t()) :: JSend.t()

  @doc ~S"""
  Revoke an API key by ID.
  """
  @callback revoke_api_key(String.t()) :: JSend.t()

  @doc ~S"""
  Parse a user agent string.
  """
  @callback parse_user_agent(String.t()) :: JSend.t()
end
