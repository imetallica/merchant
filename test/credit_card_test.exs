defmodule CreditCardTest do
  use ExUnit.Case
  
  test "Select card type VISA" do
    cards = [
      %Merchant.CreditCard{number: "4929761476810483"},
      %Merchant.CreditCard{number: "4168823126302806"},
      %Merchant.CreditCard{number: "4979958067015766"},
      %Merchant.CreditCard{number: "4539433918219"},
      %Merchant.CreditCard{number: "4024007131572"}
    ]

    cards
    |> Enum.map(fn card -> Merchant.CreditCard.select_type card end)
    |> Enum.map(fn card -> assert :visa == card.type end)
  end

  test "Select card type MASTERCARD" do
    cards = [
      %Merchant.CreditCard{number: "5564382307816677"},
      %Merchant.CreditCard{number: "5149260170727540"},
      %Merchant.CreditCard{number: "5175625330469240"},
      %Merchant.CreditCard{number: "5128360905292474"},
      %Merchant.CreditCard{number: "5237934171409240"}
    ]

    cards
    |> Enum.map(fn card -> Merchant.CreditCard.select_type card end)
    |> Enum.map(fn card -> assert :mastercard == card.type end)
  end

  test "Select card type DISCOVER" do
    cards = [
      %Merchant.CreditCard{number: "6011975206356310"},
      %Merchant.CreditCard{number: "6011862489053030"},
      %Merchant.CreditCard{number: "6011388129876853"},
      %Merchant.CreditCard{number: "6011036192661369"},
      %Merchant.CreditCard{number: "6011008539042009"}
    ]

    cards
    |> Enum.map(fn card -> Merchant.CreditCard.select_type card end)
    |> Enum.map(fn card -> assert :discover == card.type end)
  end

  test "Select card type DINERS CLUB" do
    cards = [
      %Merchant.CreditCard{number: "36464856368515"},
      %Merchant.CreditCard{number: "30001215293897"},
      %Merchant.CreditCard{number: "30358991176641"},
      %Merchant.CreditCard{number: "30172057119993"},
      %Merchant.CreditCard{number: "30395009928480"}
    ]

    cards
    |> Enum.map(fn card -> Merchant.CreditCard.select_type card end)
    |> Enum.map(fn card -> assert :diners == card.type end)
  end

  test "Select card type AMERICAN EXPRESS" do
    cards = [
      %Merchant.CreditCard{number: "371101841746727"},
      %Merchant.CreditCard{number: "347301212491744"},
      %Merchant.CreditCard{number: "379762618455263"},
      %Merchant.CreditCard{number: "372902982322148"},
      %Merchant.CreditCard{number: "375684291886917"}
    ]

    cards
    |> Enum.map(fn card -> Merchant.CreditCard.select_type card end)
    |> Enum.map(fn card -> assert :amex == card.type end)
  end

  test "Check if card number is valid" do
    cards = [
      %Merchant.CreditCard{number: "4929761476810483"},
      %Merchant.CreditCard{number: "4024007131572"},
      %Merchant.CreditCard{number: "371101841746727"},
      %Merchant.CreditCard{number: "347301212491744"},
      %Merchant.CreditCard{number: "36464856368515"},
      %Merchant.CreditCard{number: "30001215293897"},
      %Merchant.CreditCard{number: "6011975206356310"},
      %Merchant.CreditCard{number: "6011862489053030"},
      %Merchant.CreditCard{number: "5128360905292474"},
      %Merchant.CreditCard{number: "5237934171409240"}
    ]

    cards
    |> Enum.map(fn card -> assert Merchant.CreditCard.valid?(card) end)
  end
end