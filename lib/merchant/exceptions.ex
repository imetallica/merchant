defmodule Merchant.Exceptions do

  defmodule Gateway.UnauthorizedError do
    @moduledoc """
    Happens when we have an HTTP 401 status response.
    """

    defexception [:message]

    def exception(msg) do
      m = """
      There was an problem sending the request.

      These are what was received:

      #{inspect msg.response, limit: :infinity}

      ------------------------------------------

      And this is what was sent:

      #{inspect msg.request, limit: :infinity}
      """

      %Gateway.UnauthorizedError{message: m}
    end
  end
  
end