# Merchant [![Build Status](https://travis-ci.org/imetallica/merchant.svg?branch=master)](https://travis-ci.org/imetallica/merchant)

**Use various payment gateways directly into your project**

## Installation

Add merchant to your list of dependencies in `mix.exs`:
```
    def deps do
      [{:merchant, "~> 0.1.0"}]
    end
```

## Implementation details

This library integrates with the payment gateways via REST APIs. It also
has helpers to help you integrate easily with your current application.

## Roadmap

Merchant has in mind an easy way to allow developers to implement their 
own payment gateways. 

  - Luhn's Algorithm                [OK]
  - Support for Visa                [OK]
  - Support for MasterCard          [OK]
  - Support for American Express    [OK]
  - Support for Diners Club         [OK]
  - Support for Discover            [OK]
  - PayPal support                  [COMPLETED]
  - Stripe support                  [NOT STARTED]
  
## Support and contributing

You can always do pull requests and fill in eventual issues.