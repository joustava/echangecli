require 'exchangecli/configuration'
require 'exchangecli/httpclient'

module ExchangeCLI
  class CurrencyLayer
    # NOTE: See https://currencylayer.com/quickstart

    def initialize(options = {})
      @http = options[:http] || ExchangeCLI::HTTPClient.new
      @base_url = options[:base_url] || ExchangeCLI::configuration.currencylayer_base_url
      @access_key = options[:access_key] || ExchangeCLI::configuration.currencylayer_access_key
      @default = {
        source: 'USD',
        currencies: []
      }
    end

    def quotes(endpoint, options = {})
      uri = "#{@base_url}#{endpoint}"

      @http.get(uri, query(@default.merge(options)))
    end


    private

    def query(options)
      options[:currencies] << options[:source] unless options[:source] == @default[:source]

      params = {
        access_key: @access_key,
        source: @default[:source],
        format: 1
      }

      if(options[:date])
        params[:date] = options[:date]
      end

      if(options[:currencies])
        params[:currencies] = options[:currencies]
      end

      params
    end
  end
end
