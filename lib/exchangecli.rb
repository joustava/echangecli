require 'dotenv/load' # temp
require 'thor'
require 'date'
require "exchangecli/version"
require "exchangecli/currency"

module ExchangeCLI
  class CLI < Thor

    desc "version", "Show version"
    def version
      say ExchangeCLI::VERSION
    end

    desc "rates BASE TARGETS", "Show TARGET currency rates for given BASE currency."
    method_options %w( --date -d) => Date.today
    long_desc <<-DESC
      Returns the exchange rate(s) of a given base currency into one or more target currencies.

      With -d option, rates will give exchange rates of specified date.
    DESC
    def rates(base, *targets)
      if options[:date]
        say ExchangeCLI::Currency.new(base).history(targets, options[:date])
      else
        say ExchangeCLI::Currency.new(base).rates(targets)
      end
    end

    desc "exchange BASE TARGETS", "Exchange BASE currency value to one or more TARGET currency values."
    method_options %w( --date -d) => Date.today
    method_options %w( --unit -u) => :required
    long_desc <<-DESC
      Return the value (such as "1.23") of a given BASE currency (such as "EUR")
      into one or multiple target currencies.

      Required --unit (-u) option, exchange will give exchange values based on the rates of specified date.
      With -d option, exchange will give exchange values based on the rates of specified date.
    DESC
    def exchange(base, *targets)
      if options[:date]
        say ExchangeCLI::Currency.new(base).history(targets, options[:date], options[:unit])
      else
        say ExchangeCLI::Currency.new(base).exchange(targets, options[:unit])
      end
    end

    desc "best BASE TARGET", "Show best rate in the last 7 days for given BASE and TARGET currency."
    long_desc <<-DESC
      Return the best exchange rate (highest) and the corresponding date of the
      last seven days for a given BASE and a given TARGET currency.
    DESC
    def best(base, target)
      say ExchangeCLI::Currency.new(base).best(target)
    end

  end
end
