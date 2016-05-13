# Merchant

**Use various payment gateways directly into your project**

## Installation

Add merchant to your list of dependencies in `mix.exs`:
```
    def deps do
      [{:merchant, "~> 0.0.1-alpha"}]
    end
```

## Implementation details

This library integrates with the payment gateways via REST APIs. It also
has helpers to help you integrate easily with your current application.

## Roadmap

Merchant has in mind an easy way to allow developers to implement their 
own payment gateways and more credit cards. 

  - Luhn's Algorithm                [OK]
  - Support for Visa                [OK]
  - Support for MasterCard          [OK]
  - Support for American Express    [NOT STARTED]
  - PayPal support                  [IN PROGRESS]
  - Stripe support                  [NOT STARTED]
  
## Support and contributing

You can always do pull requests and fill in eventual issues.