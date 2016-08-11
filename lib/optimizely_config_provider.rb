require 'active_support'
require 'json'
require 'net/http'
require 'singleton'
require 'optimizely'
require 'optimizely_config_provider/cache'
require 'optimizely_config_provider/configuration'
require 'optimizely_config_provider/datafile_fetcher'
require 'optimizely_config_provider/variation'
require 'optimizely_config_provider/optimizely_sdk'
require 'optimizely_config_provider/helpers/support'

module OptimizelyConfigProvider

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
