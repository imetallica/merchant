defmodule Merchant.Gateway.Helpers do
  @moduledoc """
  Helper functions used to implement gateways.
  """

  @doc """
  Generates a random key, usually to be sent together with headers.
  """
  def idempotency, do: :crypto.strong_rand_bytes(40) |> :base64.encode

  @doc """
  Encode raw `client_id:client_password` keys.
  """
  def encode_credentials(cred), do: cred |> :base64.encode

end