require 'net/http'
require 'json'
require 'exchangecli/config'

module ExchangeCLI
  class CurrencyLayer
    # SEE: https://currencylayer.com/quickstart

    def initialize(options = {})
      @base_url = options[:base_url] || ExchangeCLI::Config::CURRENCYLAYER_BASE_URL
      @access_key = options[:access_key] || ENV['ACCESS_KEY']
      @default = {
        source: 'USD',
        currencies: []
      }
    end

    def quotes(endpoint, options = {})
      uri = URI("#{@base_url}#{endpoint}")
      uri.query = query(@default.merge(options))

      res = Net::HTTP.get_response(uri)
      JSON.parse(res.body, {symbolize_names: true}) if res.is_a?(Net::HTTPSuccess)
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

      URI.encode_www_form(params)
    end
  end
end
