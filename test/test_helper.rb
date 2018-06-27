$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'dotenv/load'
require "exchangecli"
require "exchangecli/config"
require "exchangecli/currencylayer"

require "minitest/autorun"
require "minitest/rg"
