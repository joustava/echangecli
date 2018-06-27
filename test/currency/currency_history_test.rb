require "test_helper"
require 'json'

class ExchangeCLI::CurrencyTest < Minitest::Test

  def setup()
    @api = ::ExchangeCLI::CurrencyLayer.new
  end

  # Currency#exchange
  def test_history_from_usd

    @api.stub :quotes, mocked_rate do
      currency = ::ExchangeCLI::Currency.new('USD', api: @api)
      history = currency.history(['EUR'], "2018-01-07")

      assert (history.keys == [:USDEUR])
      assert_in_delta history[:USDEUR], 0.8576, 0.0000001
    end
  end

  def test_histories_from_usd

    @api.stub :quotes, mocked_rates do
      currency = ::ExchangeCLI::Currency.new('USD', api: @api)
      history = currency.history(['EUR', 'GBP', 'JPY'], "2018-01-07")

      assert (history.keys == [:USDEUR, :USDGBP, :USDJPY])

      assert_in_delta history[:USDEUR], 0.8313285780, 0.0000001
      assert_in_delta history[:USDGBP], 0.7370938511, 0.0000001
      assert_in_delta history[:USDJPY], 113.0343965954, 0.0000001
    end
  end

  def test_history_inverse

    @api.stub :quotes, mocked_rates do
      currency = ::ExchangeCLI::Currency.new('EUR', api: @api)
      history = currency.history(['USD', 'GBP', 'JPY'], "2018-01-07")

      assert (history.keys == [:EURUSD, :EURGBP, :EURJPY])

      assert_in_delta history[:EURUSD], 1.2028938093, 0.0000001
      assert_in_delta history[:EURGBP], 0.8866456304, 0.0000001
      assert_in_delta history[:EURJPY] ,135.9683759066, 0.0000001
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
