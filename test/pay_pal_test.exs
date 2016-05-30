defmodule PayPalTest do
  use ExUnit.Case

  @money %Merchant.Currency{type: "USD", amount: Decimal.new(45.21)}
  @card %Merchant.CreditCard{
    number: "4929761476810483",
    type: :visa,
    check_digit: 435,
    expire_month: 11,
    expire_year: 2033,
  }

  @authorization Merchant.Gateway.PayPal.authorize(@money, @card)
  
  test "Get authorization" do
    assert {:ok, %Merchant.Gateway.PayPal.Authorization{}} = @authorization

  end
end