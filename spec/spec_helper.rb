require 'bundler/setup'
require 'webmock/rspec'
Bundler.setup

require 'optimizely_config_provider' # and any other gems you need

RSpec.configure do |config|
  # some (optional) config here

  config.before do
    OptimizelyConfigProvider.configure do |config|
      config.config_endpoint = 'https://cdn.optimizely.com/json/5960232316.json'
    end
  end
end
