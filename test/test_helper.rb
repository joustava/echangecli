$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'dotenv/load'
require "exchangecli"
require "exchangecli/config"
require "exchangecli/currency"
require "exchangecli/currencylayer"
require "exchangecli/httpclient"
require "exchangecli/notifiers/slack"

require "minitest/autorun"
require "minitest/rg"
