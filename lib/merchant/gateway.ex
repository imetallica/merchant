defmodule Merchant.Gateway do

  @type card  :: %Merchant.CreditCard{}
  @type money :: %Merchant.Currency{}

  @callback authorize(money, card) :: map
  #@callback capture(money, authorization) :: map
  #@callback void(identification)
  #@callback credit(money, identification)
  #@callback store_client(card)
  #@callback remove_client(card)

end