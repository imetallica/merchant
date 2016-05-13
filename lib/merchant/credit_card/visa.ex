defmodule Merchant.CreditCard.Visa do
  @moduledoc """
  The implementation of the CreditCard protocol for Visa.
  """
  @derive Merchant.CreditCard
  defstruct [number: :nil, check_digit: :nil, regex: ~r/^4[0-9]{12}(?:[0-9]{3})?$/]

end