defmodule Merchant.Currency do
  @moduledoc """
  A struct that holds the `type` (USD, EUR, BRL) and the `ammount` (`%Decimal{}`).
  """
  defstruct [:type, :amount]
end