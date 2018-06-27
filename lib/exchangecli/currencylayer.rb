require 'net/http'
require 'json'
require 'exchangecli/config'

module ExchangeCLI
  class CurrencyLayer
    # SEE: https://currencylayer.com/quickstart

    def initialize(options = {})
      @base_url = options[:base_url] || ExchangeCLI::Config::CURRENCYLAYER_BASE_URL
      @access_key = options[:access_key] || ENV['ACCESS_KEY']
    end

    def quotes(endpoint, date=false)
      uri = URI("#{@base_url}#{endpoint}")
      uri.query = query(date)

      res = Net::HTTP.get_response(uri)
      JSON.parse(res.body, {symbolize_names: true}) if res.is_a?(Net::HTTPSuccess)
    end


    private

    def query(date)
      params = {
        access_key: @access_key,
        source: 'USD',
        format: 1
      }

      if(date)
        params[:date] = date
      end
      
      URI.encode_www_form(params)
    end
  end
end
