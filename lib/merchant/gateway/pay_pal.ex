defmodule Merchant.Gateway.PayPal do
  @doc false
  @behaviour Merchant.Gateway
  alias Merchant.Gateway.Helpers
  require Logger

  @live? Keyword.fetch!(Application.get_env(:merchant, PayPal), :live)
  @client_id Keyword.fetch!(Application.get_env(:merchant, PayPal), :client_id)
  @client_secret Keyword.fetch!(Application.get_env(:merchant, PayPal), :client_secret)

  @live_url "https://api.paypal.com"
  @sandbox_url "https://api.sandbox.paypal.com"
  @token_url "/v1/oauth2/token/"
  @authorization_url "/v1/payments/payment/"
  @capture_url "/v1/payments/authorization/"
  @void_url "/v1/payments/authorization/"
  @refund_url "/v1/payments/capture/"

  def authorize(card, currency) do
    with {:ok, body} <- Poison.encode(%{
                          intent: "authorize",
                          payer: %{
                            payment_method: "credit_card",
                            funding_instruments: [serialize_card(card)],
                          },
                          transactions: [serialize_currency(currency)]
                        }),
         {:ok, token} <- get_auth_token,
         headers = gen_headers(:authorization, token),
         {:ok, response} <- (process_url(@authorization_url) |> HTTPoison.post(body, headers) |> Helpers.process_response),
         {:ok, auth} <- Poison.decode(response),
         transactions = auth["transactions"],
         transaction = List.first(transactions),
         related_resources = List.first(transaction["related_resources"]),
         authorization = related_resources["authorization"],
         id = authorization["id"],
         a = %Merchant.Gateway.Payment{__meta__: %{transaction_id: auth["id"], auth_id: id},
                                       state: auth["state"],
                                       currency: currency.type,
                                       amount: currency.amount},
         _ = Logger.debug(inspect a),
         do: a
  end

  def capture({:error, reason}), do: {:error, reason}
  def capture(%Merchant.Gateway.Payment{} = payment) do
    with {:ok, body} <- Poison.encode(%{
                          is_final_capture: true,
                          amount: %{
                            currency: payment.currency,
                            total: Decimal.to_string(payment.amount)
                          }
                        }),
         {:ok, token} <- get_auth_token,
         headers = gen_headers(:capture, token),
         url = process_url(@capture_url <> payment.__meta__.auth_id <> "/capture"),
         {:ok, response} <- (url |> HTTPoison.post(body, headers) |> Helpers.process_response),
         {:ok, auth} <- Poison.decode(response),
         meta = payment.__meta__,
         fee = auth["transaction_fee"],
         meta = Map.put(meta, :capture_id, auth["id"]),
         meta = Map.put(meta, :gateway_fee, Decimal.new(fee["value"])),
         a = %{payment | state: auth["state"], __meta__: meta},
         _ = Logger.debug(inspect a),
         do: a
  end

  def void({:error, reason}), do: {:error, reason}
  def void(%Merchant.Gateway.Payment{} = payment) do
    with {:ok, token} <- get_auth_token,
         headers = gen_headers(:void, token),
         url = process_url(@void_url <> payment.__meta__.auth_id <> "/void"),
         {:ok, response} <- (url |> HTTPoison.post("", headers) |> Helpers.process_response),
         {:ok, auth} <- Poison.decode(response),
         a = %{payment | state: auth["state"]},
         _ = Logger.debug(inspect a),
         do: a
  end

  def refund({:error, reason}), do: {:error, reason}
  def refund(%Merchant.Gateway.Payment{} = payment) do
    with {:ok, body} <- Poison.encode(%{
                          amount: %{
                            currency: payment.currency,
                            total: Decimal.to_string(payment.amount)
                          }
                        }),
         {:ok, token} <- get_auth_token,
         headers = gen_headers(:refund, token),
         url = process_url(@refund_url <> payment.__meta__.capture_id <> "/refund"),
         {:ok, response} <- (url |> HTTPoison.post(body, headers) |> Helpers.process_response),
         {:ok, auth} <- Poison.decode(response),
         a = %{payment | state: auth["state"]},
         _ = Logger.debug(inspect a),
         do: a
  end

  defp serialize_card(card) do
    %{
      credit_card: %{
        number: card.number,
        type: card.type,
        expire_month: card.expire_month,
        expire_year: card.expire_year,
        cvv2: card.check_digit,
        first_name: card.first_name,
        last_name: card.last_name
      }
    }
  end

  defp serialize_currency(currency) do
    %{
      amount: %{
        total: Decimal.to_string(currency.amount),
        currency: currency.type
      }
    }
  end

  defp gen_headers(action, param \\ :nil) do
    case action do
      :token ->
        %{"Authorization" => "Basic " <> Helpers.encode_credentials(@client_id <> ":" <> @client_secret),
          "Accept" => "application/json",
          "PayPal-Request-Id" => Helpers.idempotency,
          "content-type" => "application/x-www-form-urlencoded"}
      :authorization ->
        %{"Authorization" => "Bearer #{param}",
          "PayPal-Request-Id" => Helpers.idempotency,
          "content-type" => "application/json"}
      :capture ->
        %{"Authorization" => "Bearer #{param}",
          "PayPal-Request-Id" => Helpers.idempotency,
          "content-type" => "application/json"}
      :void ->
        %{"Authorization" => "Bearer #{param}",
          "PayPal-Request-Id" => Helpers.idempotency,
          "content-type" => "application/json"}
      :refund ->
        %{"Authorization" => "Bearer #{param}",
          "PayPal-Request-Id" => Helpers.idempotency,
          "content-type" => "application/json"}
    end
  end

  defp get_auth_token do
    headers = gen_headers(:token)
    body = "grant_type=client_credentials"
    with {:ok, response} <- (@token_url |> process_url |> HTTPoison.post(body, headers) |> Helpers.process_response),
         {:ok, dec_resp} <- Poison.decode(response),
         do: {:ok, dec_resp["access_token"]}
  end

  defp process_url(url) do
    if @live? do
        Logger.debug "#{inspect @live_url <> url}"
        @live_url <> url
    else
        Logger.debug "#{inspect @sandbox_url <> url}"
        @sandbox_url <> url
    end
  end
end