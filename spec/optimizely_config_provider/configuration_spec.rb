require 'spec_helper'

RSpec.describe OptimizelyConfigProvider::Configuration do


  describe '#config_endpoint' do

    subject { OptimizelyConfigProvider::Configuration.new }

    it 'has a default value of http://foo.com' do
      expect(subject.config_endpoint).to eq('http://foo.com')
    end

  end
end
