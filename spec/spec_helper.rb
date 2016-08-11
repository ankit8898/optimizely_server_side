require 'bundler/setup'
require 'webmock/rspec'
Bundler.setup

require "codeclimate-test-reporter"

require 'optimizely_server_side'

CodeClimate::TestReporter.start

RSpec.configure do |config|
  # some (optional) config here

  config.before do
    OptimizelyServerSide.configure do |config|
      config.config_endpoint = 'https://cdn.optimizely.com/json/5960232316.json'
    end
  end
end
