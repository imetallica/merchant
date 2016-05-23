defmodule Merchant.Gateway.PayPal do
  use Merchant.Gateway

  @live? Application.get_env(:merchant, PayPal) |> Keyword.fetch!(:live)
  @client_id Application.get_env(:merchant, PayPal) |> Keyword.fetch!(:client_id)
  @client_secret Application.get_env(:merchant, PayPal) |> Keyword.fetch!(:client_secret)

  @live_url "https://api.paypal.com"
  @sandbox_url "https://api.sandbox.paypal.com"

  defp process_url(url) do
    case @live? do
      true -> @live_url <> url
      false -> @sandbox_url <> url
    end
  end

  def get_auth_token do
    headers = %{"Authorization" => "Basic "<> encode_credentials(@client_id <> ":" <> @client_secret),
                "Accept" => "application/json",
                "PayPal-Request-Id" => idempotency,
                "content-type" => "application/x-www-form-urlencoded"}
    body = "grant_type=client_credentials"
    Logger.debug Kernel.inspect headers
    Logger.debug Kernel.inspect body
    Merchant.Gateway.PayPal.post("/v1/oauth2/token", body, headers) |> process_response
  end


  defp process_response({:ok, resp}) do
    Logger.debug "We could reach PayPal's API."

  end

  defp process_response(_resp) do
    Logger.debug "Problem connecting with the API."
  end

end