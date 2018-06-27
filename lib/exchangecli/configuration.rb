require 'yaml'

module ExchangeCLI
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.configured?
    File.exists?(Configuration::CONFIG_FILE)
  end

  class Configuration
    CONFIG_FILE = "#{ENV['HOME']}/.exchangeclirc"
    VALID_KEYS = [
      :currencylayer_base_url,
      :currencylayer_access_key,
      :slack_webhook_url
    ]
    attr_accessor(*VALID_KEYS)

    def load
      config = YAML::load(IO.read(CONFIG_FILE))
      configure(config)
    end

    def init(options = {})
      config = {}
      VALID_KEYS.each { |key| config[key] = options[key] }
      File.open(CONFIG_FILE, "w+") {|f| f.write config.to_yaml }
    end

    private

    def configure(options = {})
      options.each do |k, v|
        self.send("#{k}=", v) if VALID_KEYS.include? k
      end
    end

  end
end
