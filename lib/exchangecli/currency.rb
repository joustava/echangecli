require 'date'
require "exchangecli/currencylayer"

module ExchangeCLI
  class Currency

    def initialize(source, options = {})
      @source = source.upcase
      @api = options[:api] || ::ExchangeCLI::CurrencyLayer.new
    end

    def rates(targets)
      exchange(targets, 1)
    end

    def exchange(targets, value)
      quotes = @api.quotes('live', {
        source: @source,
        currencies: targets,
      })[:quotes]

      convert(quotes, targets, value)
    end

    private

    def convert(quotes, targets, value)
      values = {}
      targets.each { |t|
        target = t.upcase
        key = :"#{@source}#{target}"

        next if @source == target # not interested
        if (@source == 'USD') # rates as is.
          values[key] = quotes[key] * value.to_f
        elsif (target == 'USD') # inverse
          values[key] = 1/quotes[:"#{target}#{@source}"]  * value.to_f
        else # cross calculation
          values[key] = 1/quotes[:"USD#{@source}"] * quotes[:"USD#{target}"] * value.to_f
        end
      }

      values
    end

  end
end
