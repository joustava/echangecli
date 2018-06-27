$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'dotenv/load'
#require "exchangecli"
require "exchangecli/configuration"
ExchangeCLI.configure do |c|
  c.currencylayer_base_url = ENV['BASE_URL']
  c.currencylayer_access_key = ENV['ACCESS_KEY']
  c.slack_webhook_url = ENV['WEBHOOK']
end

require "exchangecli/currency"
require "exchangecli/currencylayer"
require "exchangecli/httpclient"
require "exchangecli/notifiers/slack"

require "minitest/autorun"
require "minitest/rg"
