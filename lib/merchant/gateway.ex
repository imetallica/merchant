defmodule Merchant.Gateway do
  @moduledoc """
  Behaviour for Gateway implementation.

  When implementing a new gateway, you should use `@behaviour Merchant.Gateway`.
  """

  @type card :: %Merchant.CreditCard{}
  @type currency :: %Merchant.Currency{}
  @type payment :: %Merchant.Gateway.Payment{}

  @doc """
  Authorizes a payment for later capture.
  """
  @callback authorize(card, currency) :: payment | {:error, String.t}

  @doc """
  Captures a previously authorized payment. Please, bear in mind different gateways have different expire times when
  authorized payments are not captured.
  """
  @callback capture(payment)          :: payment | {:error, String.t}

  @doc """
  Voids an authorized payment.
  """
  @callback void(payment)             :: payment | {:error, String.t}

  @doc """
  Refunds a captured payment.
  """
  @callback refund(payment)           :: payment | {:error, String.t}

  defmodule Payment do
    @moduledoc """
    The Payment struct holds the entire lifecycle of the payment, from it's authorization by the Gateway untill it's
    capture and/or void-refund.

    A Payment has the following fields:
      - state: Means on which state is the actual Payment.
      - currency: Is the currency code, like: USD, EUR, BRL.
      - amount: Is the quantity charged. It's a `%Decimal{}` number.
      - __meta__: This field is specific for each gateway. For example, PayPal returns how much it charged from the
      transaction we did.
    """
    defstruct [:state, :currency, :amount, :__meta__]
  end

end