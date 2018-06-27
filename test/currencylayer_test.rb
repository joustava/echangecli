require "test_helper"

class ExchangeCLI::CurrencyLayerTest < Minitest::Test

  def test_fetching_live_endpoint
    api = ::ExchangeCLI::CurrencyLayer.new
    body = api.quotes("live")

    assert body.keys == [
      :success,
      :terms,
      :privacy,
      :timestamp,
      :source,
      :quotes
    ]
  end

  def test_fetching_historical_endpoint
    api = ::ExchangeCLI::CurrencyLayer.new
    body = api.quotes("historical", {source: "usd", date: "2018-01-07"})

    assert body.keys == [
      :success,
      :terms,
      :privacy,
      :historical,
      :date,
      :timestamp,
      :source,
      :quotes
    ]
  end

  # Will error unless you pay
  def test_fetching_live_endpoint_non_usd
    api = ::ExchangeCLI::CurrencyLayer.new
    body = api.quotes('historical', {source: "eur", date: "2018-01-07"})

    assert body.keys == [
      :success,
      :error
    ]
  end
end
