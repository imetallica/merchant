defmodule Merchant.Gateway.Helpers do
  @moduledoc """
  Helper functions used to implement gateways.
  """

  @doc """
  Generates a random key, usually to be sent together with headers.
  """
  def idempotency, do: :base64.encode(:crypto.strong_rand_bytes(40))

  @doc """
  Encode raw `client_id:client_password` keys.
  """
  def encode_credentials(cred), do: cred |> :base64.encode

  def process_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, body}
  def process_response({:ok, %HTTPoison.Response{status_code: 201, body: body}}), do: {:ok, body}
  def process_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}), do: {:error, status_code, Poison.decode!(body)}
  def process_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, Poison.decode!(reason)}

end