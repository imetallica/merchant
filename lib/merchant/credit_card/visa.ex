defmodule Merchant.CreditCard.Visa do
  @derive Merchant.CreditCard
  defstruct [number: :nil, check_digit: :nil, regex: ~r/^4[0-9]{12}(?:[0-9]{3})?$/]

end