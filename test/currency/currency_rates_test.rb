require "test_helper"
require 'json'

class ExchangeCLI::CurrencyTest < Minitest::Test

  def setup
    @api = api = ::ExchangeCLI::CurrencyLayer.new
  end

  # Currency#rates
  def test_rate_from_usd

    @api.stub :quotes, mocked_rate do
      currency = ::ExchangeCLI::Currency.new('USD', api: @api)
      rates = currency.rates(['EUR'])

      assert (rates.keys == [:USDEUR])
      assert_in_delta rates[:USDEUR], 0.8576, 0.0001
    end
  end

  def test_rates_from_usd

    @api.stub :quotes, mocked_rates do
      currency = ::ExchangeCLI::Currency.new('USD', api: @api)
      rates = currency.rates(['EUR', 'GBP', 'JPY'])

      assert (rates.keys == [:USDEUR, :USDGBP, :USDJPY])
      assert_in_delta rates[:USDEUR], 0.8313285780, 0.0000000001
      assert_in_delta rates[:USDGBP], 0.7370938511, 0.0000000001
      assert_in_delta rates[:USDJPY] ,113.0343965954, 0.0000000001
    end
  end

  def test_inverse_rates

    @api.stub :quotes, mocked_rates do
      currency = ::ExchangeCLI::Currency.new('EUR', api: @api)
      rates = currency.rates(['USD', 'GBP', 'JPY'])

      assert (rates.keys == [:EURUSD, :EURGBP, :EURJPY])
      assert_in_delta rates[:EURUSD], 1.2028938093, 0.0000000001
      assert_in_delta rates[:EURGBP], 0.8866456304, 0.0000000001
      assert_in_delta rates[:EURJPY] ,135.9683759066, 0.0000000001
    end
  end



  def mocked_rate
    JSON.parse('{
      "success":true,
      "terms":"https:\/\/currencylayer.com\/terms",
      "privacy":"https:\/\/currencylayer.com\/privacy",
      "timestamp":1530086587,
      "source":"USD",
      "quotes":{
        "USDEUR":0.8576
      }
    }', {symbolize_names: true})
  end

  def mocked_rates
    JSON.parse('{
      "success":true,
      "terms":"https:\/\/currencylayer.com\/terms",
      "privacy":"https:\/\/currencylayer.com\/privacy",
      "historical":true,
      "date":"2018-01-07",
      "timestamp":1515369599,
      "source":"USD",
      "quotes":{
        "USDEUR": 0.8313285780,
        "USDGBP": 0.7370938511,
        "USDJPY": 113.0343965954
      }
    }', {symbolize_names: true})
  end
end
