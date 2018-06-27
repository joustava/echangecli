require "test_helper"
require 'json'

class ExchangeCLI::CurrencyTest < Minitest::Test

  # Currency#best
  def test_best_from_usd
    @api = ::ExchangeCLI::CurrencyLayer.new

    @api.stub :quotes, mocked_day do
      currency = ::ExchangeCLI::Currency.new('USD', api: @api)
      best = currency.best('EUR')


      assert_in_delta best[:USDEUR], 7
      assert best[:date]
    end
  end


  def mocked_day
    rate = 8
    Proc.new {
      rate = rate - 1
      {
        "success":true,
        "terms":"https:\/\/currencylayer.com\/terms",
        "privacy":"https:\/\/currencylayer.com\/privacy",
        "historical":true,
        "date": "dummy",
        "timestamp":1515369599,
        "source":"USD",
        "quotes":{
          "USDEUR": rate
        }
      }
    }
  end
end
