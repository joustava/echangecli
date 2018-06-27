require "test_helper"
require 'json'

class ExchangeCLI::CurrencyTest < Minitest::Test

  def setup()
    @api = ::ExchangeCLI::CurrencyLayer.new
  end

  # Currency#exchange
  def test_exchange_from_usd

    @api.stub :quotes, mocked_rate do
      currency = ::ExchangeCLI::Currency.new('USD', api: @api)
      exchange = currency.exchange(['EUR'], 500)

      assert (exchange.keys == [:USDEUR])
      assert_in_delta exchange[:USDEUR], 0.8576 * 500, 0.0000001
    end
  end

  def test_exchanges_from_usd

    @api.stub :quotes, mocked_rates do
      currency = ::ExchangeCLI::Currency.new('USD', api: @api)
      exchange = currency.exchange(['EUR', 'GBP', 'JPY'], 500)

      assert (exchange.keys == [:USDEUR, :USDGBP, :USDJPY])

      assert_in_delta exchange[:USDEUR], 0.8313285780 * 500, 0.0000001
      assert_in_delta exchange[:USDGBP], 0.7370938511 * 500, 0.0000001
      assert_in_delta exchange[:USDJPY], 113.0343965954 * 500, 0.0000001
    end
  end

  def test_inverse_exchange

    @api.stub :quotes, mocked_rates do
      currency = ::ExchangeCLI::Currency.new('EUR', api: @api)
      exchange = currency.exchange(['USD', 'GBP', 'JPY'], 500)

      assert (exchange.keys == [:EURUSD, :EURGBP, :EURJPY])

      assert_in_delta exchange[:EURUSD], 1.2028938093 * 500, 0.0000001
      assert_in_delta exchange[:EURGBP], 0.8866456304 * 500, 0.0000001
      assert_in_delta exchange[:EURJPY] ,135.9683759066 * 500, 0.0000001
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
