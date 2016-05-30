defmodule PayPalTest do
  use ExUnit.Case
  alias Merchant.Gateway.PayPal

  @currency %Merchant.Currency{type: "USD", amount: Decimal.new(45.21)}
  @card %Merchant.CreditCard{
    number: "4929761476810483",
    type: :visa,
    check_digit: 435,
    expire_month: 11,
    expire_year: 2033,
  }

  setup do
    {:ok, payment: PayPal.authorize(@card, @currency)}
  end

  test "Get authorization", context do
    assert %Merchant.Gateway.Payment{state: "approved"} = context[:payment]
  end

  test "Capture authorization", context do
    assert %Merchant.Gateway.Payment{state: "completed"} = (context[:payment] |> PayPal.capture)
  end

  test "Void authorization", context do
    assert %Merchant.Gateway.Payment{state: "voided"} = (context[:payment] |> PayPal.void)
  end

  test "Refund payment", context do
    assert %Merchant.Gateway.Payment{state: "completed"} = (context[:payment] |> PayPal.capture |> PayPal.refund)
  end

end