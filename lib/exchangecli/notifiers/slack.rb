require 'exchangecli/httpclient'

module ExchangeCLI
  module Notifiers
    class Slack
      # NOTE: See https://api.slack.com/incoming-webhooks

      def initialize(options = {})
        @http = options[:http] || ExchangeCLI::HTTPClient.new
        @webhook_url = options[:webhook_url] || ENV['WEBHOOK']
        @channel = options[:channel] || "general"
        @username = options[:username] || 'Captain Hook'
        @icon_emoji = options[:icon_emoji] || ":fish:"
      end

      def notify(text)
        message = {
          text: text,
          icon_emoji: @icon_emoji,
          username: @username,
          channel: @channel
        }

        @http.post(@webhook_url, message)
      end
    end
  end
end
