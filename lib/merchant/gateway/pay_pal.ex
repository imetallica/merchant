defmodule Merchant.Gateway.PayPal do
  @behaviour Merchant.Gateway
  alias Merchant.Gateway.Helpers
  require Logger

  @live? Application.get_env(:merchant, PayPal) |> Keyword.fetch!(:live)
  @client_id Application.get_env(:merchant, PayPal) |> Keyword.fetch!(:client_id)
  @client_secret Application.get_env(:merchant, PayPal) |> Keyword.fetch!(:client_secret)

  @live_url "https://api.paypal.com"
  @sandbox_url "https://api.sandbox.paypal.com"
  @token_url "/v1/oauth2/token"
  @authorization_url "/v1/payments/payment"


  defmodule Authorization do
    @doc false
    defstruct [:id, :intent, :state, :auth_id, :currency]
  end

  def get_auth_token do
    headers = gen_headers(:token)
    body = "grant_type=client_credentials"
    with {:ok, response} <- (@token_url |> process_url |> HTTPoison.post(body, headers) |> process_response),
         {:ok, dec_resp} <- Poison.decode(response),
         do: {:ok, dec_resp["access_token"]}
  end

  def authorize(currency, card) do
    body = Poison.encode!(%{
      intent: "authorize",
      payer: %{
        payment_method: "credit_card",
        funding_instruments: [serialize_card(card)],
      },
      transactions: [serialize_transaction(currency)]
    })
    with {:ok, token} <- get_auth_token(),
         headers = gen_headers(:authorization, token),
         {:ok, response} <- (@authorization_url |> process_url |> HTTPoison.post(body, headers) |> process_response),
         {:ok, auth} <- Poison.decode(response),
         transactions = auth["transactions"],
         transaction = List.first(transactions),
         related_resources = List.first(transaction["related_resources"]),
         authorization = related_resources["authorization"],
         id = authorization["id"],
         a = %Authorization{id: auth["id"],
                            intent: auth["intent"],
                            state: auth["state"],
                            auth_id: id,
                            currency: serialize_transaction(currency)},
         do: {:ok, a}
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

  defp serialize_transaction(currency) do
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
        %{"Authorization" => "Basic "<> Helpers.encode_credentials(@client_id <> ":" <> @client_secret),
          "Accept" => "application/json",
          "PayPal-Request-Id" => Helpers.idempotency,
          "content-type" => "application/x-www-form-urlencoded"}
      :authorization ->
        %{"Authorization" => "Bearer #{param}",
          "PayPal-Request-Id" => Helpers.idempotency,
          "content-type" => "application/json"}
    end
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, body}
  defp process_response({:ok, %HTTPoison.Response{status_code: 201, body: body}}), do: {:ok, body}
  defp process_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}), do: {:error, status_code, body}
  defp process_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}

  defp process_url(url) do
    case @live? do
      true ->
        Logger.debug "#{inspect @live_url <> url}"
        @live_url <> url
      false ->
        Logger.debug "#{inspect @sandbox_url <> url}"
        @sandbox_url <> url
    end
  end
end