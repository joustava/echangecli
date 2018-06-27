require "test_helper"

class ExchangeCLITest < Minitest::Test

  def test_fetching_live_endpoint
    api = ::ExchangeCLI::CurrencyLayer.new
    body = api.quotes('live')

    assert body.keys == [
      :success,
      :terms,
      :privacy,
      :timestamp,
      :source,
      :quotes
    ]
  end
end
