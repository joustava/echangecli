require 'date'
require "exchangecli/currencylayer"

module ExchangeCLI
  class Currency

    def initialize(source, options = {})
      @source = source.upcase
      @api = options[:api] || ::ExchangeCLI::CurrencyLayer.new
    end

    def rates(targets)
      @api.quotes('live', {
        source: @source,
        targets: targets
      })[:quotes]
    end

  end
end
