require 'date'
require "exchangecli/currencylayer"

module ExchangeCLI
  class Currency

    def initialize(source, options = {})
      @source = source.upcase
      @api = options[:api] || ::ExchangeCLI::CurrencyLayer.new
    end

    def rates(targets)
      quotes = @api.quotes('live', {
        source: @source,
        currencies: targets
      })[:quotes]

      convert(quotes, targets)
    end

    private

    def convert(quotes, targets)
      values = {}
      targets.each { |t|
        target = t.upcase
        key = :"#{@source}#{target}"

        next if @source == target # not interested
        if (@source == 'USD') # rates as is.
          values[key] = quotes[key]
        elsif (target == 'USD') # inverse
          values[key] = 1/quotes[:"#{target}#{@source}"]
        else # cross calculation
          values[key] = 1/quotes[:"USD#{@source}"] * quotes[:"USD#{target}"]
        end
      }

      values
    end

  end
end
