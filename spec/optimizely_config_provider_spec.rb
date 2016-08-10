require 'spec_helper'

RSpec.describe OptimizelyConfigProvider do

  describe "#configure" do
    before do
      OptimizelyConfigProvider.configure do |config|
        config.config_endpoint = 'https://cdn.optimizely.com/json/5960232316.json'
      end
    end


  end
end
