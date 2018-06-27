require 'thor'
require "exchangecli/version"

module ExchangeCLI
  class CLI < Thor

    desc "version", "Show version"
    def version
      say ExchangeCLI::VERSION
    end
  end
end
