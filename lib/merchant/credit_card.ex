defprotocol Merchant.CreditCard do
  @moduledoc """
  Implement this Protocol for credit cards.
  More information about the implementation can be found [here](https://en.wikipedia.org/wiki/Luhn_algorithm).
  """

  @doc """
  This function checks if the card is valid by the informed regex into the Card struct and using the Luhn's algorithm.
  """
  def valid?(card)

end

defimpl Merchant.CreditCard, for: Any do
  @doc """
   Checks if the credit card is valid.
   """
  def valid?(card) do
    case regex_valid?(card) do
      true -> card |> digits |> checksum
      _ -> false
     end
  end

  # Returns `true` if the card's number matches the regex. If it doesn't, returns `false`.
  defp regex_valid?(card) do
    case Regex.regex?(card.regex) do
      true -> Regex.match?(card.regex, card.number)
      _ -> raise "Card Regex is invalid."
    end
  end

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
    rem(total_sum, 10) == 0
  end
end