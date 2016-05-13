defmodule Merchant.CreditCard.MasterCard do
  @derive Merchant.CreditCard
  defstruct [number: :nil, check_digit: :nil, regex: ~r/^5[1-5][0-9]{14}$/]
end