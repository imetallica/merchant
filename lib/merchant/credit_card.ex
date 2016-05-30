defmodule Merchant.CreditCard do
  defstruct [number: :nil,
             check_digit: :nil,
             first_name: :nil,
             last_name: :nil,
             expire_month: :nil,
             expire_year: :nil,
             billing_address: :nil,
             type: :nil]

  @doc """
  Checks and sets the type of the credit card struct.
  """
  def select_type(card) do
    cond do
      Regex.match?(~r/^5[1-5][0-9]{14}$/, card.number) -> %{card | type: :mastercard}
      Regex.match?(~r/^4[0-9]{12}(?:[0-9]{3})?$/, card.number) -> %{card | type: :visa}
      Regex.match?(~r/^3[47][0-9]{13}$/, card.number) -> %{card | type: :amex}
      Regex.match?(~r/^3(?:0[0-5]|[68][0-9])[0-9]{11}$/, card.number) -> %{card | type: :diners}
      Regex.match?(~r/^6(?:011|5[0-9]{2})[0-9]{12}$/, card.number) -> %{card | type: :discover}
      true -> {:error, "Either invalid or not supported credit card."}
    end
  end

  @doc """
  Checks if the credit card numbers are valid with Luhn's Algorithm.
  """
  def valid?(card), do: card |> digits |> checksum

  # Receives a card String, ex: 5432187654321, slices it on its elements,
  # reverse it and returns a list with all integers.
  defp digits(card) do
    card.number |> String.codepoints |> Enum.reverse |> Enum.map(fn(e) -> String.to_integer(e) end)
  end

  defp checksum(list) do
    [_ | t] = list
    odd = Enum.take_every(list, 2)
    even = Enum.take_every(t, 2)
    sum_odds = Enum.sum odd
    sum_double_evens = Enum.map(even, fn(x) -> (2 * x) |> Integer.digits end) |> List.flatten |> Enum.sum
    total_sum = sum_odds + sum_double_evens
    case rem(total_sum, 10) do
      0 -> true
      _ -> false
    end
  end
end
