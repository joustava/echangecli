require 'dotenv/load' # temp
require 'thor'
require 'date'
require "exchangecli/version"
require "exchangecli/configuration"
require "exchangecli/currency"
require "exchangecli/notifiers/slack"

module ExchangeCLI
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "version", "Show version"
    def version
      say ExchangeCLI::VERSION
    end

    desc "init", "Configure CLI settings"
    def init
      say "Configuring CLI settings"
      base_url = "http://apilayer.net/api/"
      currencylayer_access_key = ask("What is your CurrencyLayer access token?\n", echo: false)
      slack_webhook_url = ask("What is your Slack Webhook URL?\n", echo: false)
      ExchangeCLI.configure do |c|
        c.init({
            currencylayer_base_url: base_url,
            currencylayer_access_key: currencylayer_access_key,
            slack_webhook_url: slack_webhook_url
          })
      end
    end

    desc "rates BASE TARGETS", "Show TARGET currency rates for given BASE currency."
    method_options %w( --date -d) => Date.today
    long_desc <<-DESC
      Returns the exchange rate(s) of a given base currency into one or more target currencies.

      With -d option, rates will give exchange rates of specified date.
    DESC
    def rates(base, *targets)
      return unless configured?
      header = "Rates for #{base}"
      if options[:date]
        quotes = ExchangeCLI::Currency.new(base).history(targets, options[:date])
      else
        quotes = ExchangeCLI::Currency.new(base).rates(targets)
      end
      send(header, quotes)
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
      return unless configured?
      header "Values for #{base}"
      if options[:date]
        quotes = ExchangeCLI::Currency.new(base).history(targets, options[:date], options[:unit])
      else
        quotes = ExchangeCLI::Currency.new(base).exchange(targets, options[:unit])
      end
      send(header, quotes)
    end

    desc "best BASE TARGET", "Show best rate in the last 7 days for given BASE and TARGET currency."
    long_desc <<-DESC
      Return the best exchange rate (highest) and the corresponding date of the
      last seven days for a given BASE and a given TARGET currency.
    DESC
    def best(base, target)
      return unless configured?
      quotes = ExchangeCLI::Currency.new(base).best(target)
      key = :"#{base}#{target}"
      send("Best in last 7 days for #{base}/#{target}\n#{quotes[key]} on #{quotes[:date]}")
    end


    no_commands {
      def configured?
        ExchangeCLI.configure do |c|
          begin
            c.load
          rescue => e
            say "Could not load config, run init first", :red
          end
        end
        ExchangeCLI.configured?
      end

      def send(header, quotes)
        message = "#{header}\n#{format(quotes)}"
        say message, :green
        ExchangeCLI::Notifiers::Slack.new.notify(message)
      end


      def format(quotes)
        formatted = ""
        quotes.each_pair { |k, v| formatted << "#{k}: #{v}"}
        formatted
      end
    }
  end
end
