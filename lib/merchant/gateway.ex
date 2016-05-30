defmodule Merchant.Gateway do
  @doc """
  Behaviour for Gateway implementation.

  When implementing a new gateway, you should use `@behaviour Merchant.Gateway`.
  """

  @type card :: %Merchant.CreditCard{}
  @type currency :: %Merchant.Currency{}
  @type payment :: %Merchant.Gateway.Payment{}

  @callback authorize(card, currency) :: payment | {:error, String.t}
  @callback capture(payment)          :: payment | {:error, String.t}
  @callback void(payment)             :: payment | {:error, String.t}
  @callback refund(payment)           :: payment | {:error, String.t}
  #@callback store_client(card)
  #@callback remove_client(card)

  defmodule Payment do
    defstruct [:state, :currency, :amount, :__meta__]
  end

end