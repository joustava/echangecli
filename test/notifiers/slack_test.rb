require "test_helper"
require 'json'

class ExchangeCLI::SlackTest < Minitest::Test

  # Slack#
  def test_slack_notification
    mock = MiniTest::Mock.new
    mock.expect(:post,  nil, [String, {text: "text", icon_emoji: ":fish:", username: "Captain Hook", channel: "general"}])

    slack = ::ExchangeCLI::Notifiers::Slack.new(http: mock)

    slack.notify('text')

    mock.verify
  end
end
