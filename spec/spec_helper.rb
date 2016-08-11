require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'bundler/setup'
require 'webmock/rspec'
Bundler.setup

require 'optimizely_server_side'
WebMock.disable_net_connect!(allow: 'codeclimate.com')
RSpec.configure do |config|
  # some (optional) config here

  config.before do
    OptimizelyServerSide.configure do |config|
      config.config_endpoint = 'https://cdn.optimizely.com/json/5960232316.json'
    end
  end
end
