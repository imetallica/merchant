defmodule Merchant.Exceptions do
  defmodule CreditCard.InvalidRegexError do
    defexception message: "Informed credit card has invalid regex."
  end


end