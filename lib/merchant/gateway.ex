defmodule Merchant.Gateway do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      use HTTPoison.Base
      import Merchant.Gateway
      require Logger

      def card_supported?(card), do: false
      def purchase(transaction, card), do: false


      def get_auth_token, do: raise CardNotSupported
      defp process_response(resp), do:  raise NotImplemented

      defp idempotency do
        :crypto.strong_rand_bytes(40) |> :base64.encode
      end

      defp encode_credentials(cred) do
        cred |> :base64.encode
      end

      defmodule Unauthorized do # 401 error
        defexception [:message]

        def exception(msg) do
          m = "#{Kernel.inspect msg}"
          %Unauthorized{message: m}
        end
      end

      defmodule CardNotSupported do
        defexception "The Credit Card is not supported by the Gateway."
      end

      defmodule NotImplemented do
        defexception "The current function is not implemented."
      end

      defmodule NotSupported do
        defexception "The current function is not supported."
      end


      defoverridable [get_auth_token: 0, process_response: 1]
    end
  end

end