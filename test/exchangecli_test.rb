require "test_helper"

class ExchangeCLITest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ExchangeCLI::VERSION
  end
end
