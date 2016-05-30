# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Credentials taken from https://developer.paypal.com/docs/integration/direct/make-your-first-call/
config :merchant, PayPal,
  live: false,
  client_id: "EOJ2S-Z6OoN_le_KS1d75wsZ6y0SFdVsY9183IvxFyZp",
  client_secret: "EClusMEUk8e9ihI7ZdVLF5cZ6y0SFdVsY9183IvxFyZp"